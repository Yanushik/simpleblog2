# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require 'new_relic/collection_helper'
require 'new_relic/transaction_sample'
require 'new_relic/control'
require 'new_relic/agent/transaction'
module NewRelic
  module Agent
    # a builder is created with every sampled transaction, to dynamically
    # generate the sampled data.  It is a thread-local object, and is not
    # accessed by any other thread so no need for synchronization.
    class TransactionSampleBuilder
      attr_reader :current_segment, :sample

      include NewRelic::CollectionHelper

      def initialize(time=Time.now)
        @sample = NewRelic::TransactionSample.new(time.to_f)
        @sample_start = time.to_f
        @current_segment = @sample.root_segment
      end

      def sample_id
        @sample.sample_id
      end

      def ignored?
        @ignore
      end

      def ignore_transaction
        @ignore = true
      end

      def segment_limit
        Agent.config[:'transaction_tracer.limit_segments']
      end

      def trace_entry(time)
        if @sample.count_segments < segment_limit()
          segment = @sample.create_segment(time.to_f - @sample_start)
          @current_segment.add_called_segment(segment)
          @current_segment = segment
          if @sample.count_segments == segment_limit()
            ::NewRelic::Agent.logger.debug("Segment limit of #{segment_limit} reached, ceasing collection.")
          end
          @current_segment
        end
      end

      def trace_exit(metric_name, time)
        return unless @sample.count_segments < segment_limit()
        @current_segment.metric_name = metric_name
        @current_segment.end_trace(time.to_f - @sample_start)
        @current_segment = @current_segment.parent_segment
      end

      def finish_trace(time=Time.now.to_f, custom_params={})
        # This should never get called twice, but in a rare case that we can't reproduce in house it does.
        # log forensics and return gracefully
        if @sample.frozen?
          ::NewRelic::Agent.logger.error "Unexpected double-freeze of Transaction Trace Object: \n#{@sample.to_s}"
          return
        end
        @sample.root_segment.end_trace(time.to_f - @sample_start)
        @sample.params[:custom_params] ||= {}
        @sample.params[:custom_params].merge!(normalize_params(custom_params))

        txn_info = NewRelic::Agent::TransactionInfo.get
        @sample.force_persist = txn_info.force_persist_sample?(sample)
        @sample.threshold = txn_info.transaction_trace_threshold
        @sample.freeze
        @current_segment = nil
      end

      def scope_depth
        depth = -1        # have to account for the root
        current = @current_segment

        while(current)
          depth += 1
          current = current.parent_segment
        end

        depth
      end

      def freeze
        @sample.freeze unless sample.frozen?
      end

      def set_profile(profile)
        @sample.profile = profile
      end

      def set_transaction_info(uri, params)
        if Agent.config[:capture_params]
          params = normalize_params params

          @sample.params[:request_params].merge!(params)
          @sample.params[:request_params].delete :controller
          @sample.params[:request_params].delete :action
        end
        @sample.params[:uri] ||= uri || params[:uri]
      end

      def set_transaction_name(name)
        @sample.params[:path] = name
      end

      def set_transaction_cpu_time(cpu_time)
        @sample.set_custom_param(:cpu_time, cpu_time)
      end

      def sample
        @sample
      end

    end
  end
end
