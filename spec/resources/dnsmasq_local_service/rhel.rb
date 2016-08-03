# encoding: utf-8
# frozen_string_literal: true

require_relative '../dnsmasq_local_service'

shared_context 'resources::dnsmasq_local_service::rhel' do
  include_context 'resources::dnsmasq_local_service'

  shared_examples_for 'any RHEL platform' do
    it_behaves_like 'any platform'

    context 'the :enable action' do
      include_context description

      it 'defines a NetworkManager service resource' do
        expect(chef_run.service('NetworkManager')).to do_nothing
      end

      it 'drops off a Dnsmasq NetworkManager config' do
        f = '/etc/NetworkManager/conf.d/20-dnsmasq.conf'
        expect(chef_run).to create_file(f).with(content: "[main]\ndns=none")
        expect(chef_run.file(f)).to notify('service[NetworkManager]')
          .to(:restart).immediately
      end
    end

    context 'the :disable action' do
      include_context description


      it 'defines a NetworkManager service resource' do
        expect(chef_run.service('NetworkManager')).to do_nothing
      end

      it 'deletes the Dnsmasq NetworkManager config' do
        f = '/etc/NetworkManager/conf.d/20-dnsmasq.conf'
        expect(chef_run).to delete_file(f)
        expect(chef_run.file(f)).to notify('service[NetworkManager]')
          .to(:restart).immediately
      end
    end
  end
end
