# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::dnsmasq_local_service' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local_service' }
  %i(options).each { |p| let(p) { nil } }
  let(:properties) { { options: options } }
  let(:name) { 'default' }

  shared_examples_for 'any platform' do
    context 'the default action ([:create, :enable, :start])' do
      context 'the default attributes' do
        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS=''
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end

        it 'enables the dnsmasq service' do
          expect(chef_run).to enable_service('enable dnsmasq').with(
            service_name: 'dnsmasq', supports: { restart: true, status: true }
          )
        end

        it 'starts the dnsmasq service' do
          expect(chef_run).to start_service('start dnsmasq').with(
            service_name: 'dnsmasq', supports: { restart: true, status: true }
          )
        end
      end
    end

    context 'the :create action' do
      let(:action) { :create }

      context 'the default attributes' do
        it 'creates the defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS=''
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end

      context 'a default options override' do
        let(:options) { { thing_1: true, thing_2: 'test', bad: false } }

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS='--thing-1 --thing-2=test'
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end

      context 'some extra options to merge in with the default' do
        let(:properties) { { thing_1: true, thing_2: 'test', bad: false } }

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS='--thing-1 --thing-2=test'
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end
    end

    context 'the :remove action' do
      let(:action) { :remove }

      it 'deletes the defaults file' do
        expect(chef_run).to delete_file('/etc/default/dnsmasq')
      end
    end

    %i(enable disable start stop).each do |a|
      context "the :#{a} action" do
        let(:action) { a }

        it 'passes the action on to a service resource' do
          expect(chef_run).to send("#{a}_service", "#{a} dnsmasq").with(
            service_name: 'dnsmasq', supports: { restart: true, status: true }
          )
        end
      end
    end
  end

  shared_context 'the default action ([:create, :enable, :start])' do
  end

  shared_context 'the :create action' do
    let(:action) { :create }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end
end
