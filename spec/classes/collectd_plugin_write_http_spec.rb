# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::write_http', type: :class do
  on_supported_os(baseline_os_hash).each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present and :urls => { \'collectd.org.1\' => { \'format\' => \'JSON\'}}' do
        let :params do
          {
            urls:
              {
                'collectd.org.1' =>
                  {
                    'format' => 'JSON'
                  }
              }
          }
        end

        it { is_expected.to contain_collectd__plugin('write_http') }

        it 'Will create 10-write_http.conf' do
          is_expected.to contain_file('write_http.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-write_http.conf",
            content: "#\ Generated by Puppet\n<LoadPlugin write_http>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"write_http\">\n  <URL \"collectd.org.1\">\n\n    Format \"JSON\"\n  </URL>\n\n</Plugin>\n\n"
          )
        end

        case [facts[:os]['family'], facts[:os]['release']['major']]
        when %w[RedHat 8]
          it { is_expected.to contain_package('collectd-write_http') }
        else
          it { is_expected.not_to contain_package('collectd-write_http') }
        end
      end

      context ':ensure => present and :nodes => { \'collectd\' => { \'url\' => \'collectd.org.1\', \'format\' => \'JSON\'}}' do
        let :params do
          {
            nodes:
              {
                'collectd' =>
                  {
                    'url' => 'collectd.org.1',
                    'format' => 'JSON'
                  }
              }
          }
        end

        it 'Will create 10-write_http.conf' do
          is_expected.to contain_file('write_http.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-write_http.conf",
            content: "#\ Generated by Puppet\n<LoadPlugin write_http>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"write_http\">\n  <Node \"collectd\">\n    URL \"collectd.org.1\"\n\n    Format \"JSON\"\n  </Node>\n\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => present and :nodes => { \'collectd\' => { \'url\' => \'collectd.org.1\', \'metrics\' => \'true\', \'header\' => \'foobar\'}}' do
        let :params do
          {
            nodes:
              {
                'collectd' =>
                  {
                    'url' => 'collectd.org.1',
                    'metrics' => true,
                    'header' => 'foobar'
                  }
              }
          }
        end

        it 'Will create 10-write_http.conf' do
          is_expected.to contain_file('write_http.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-write_http.conf",
            content: "#\ Generated by Puppet\n<LoadPlugin write_http>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"write_http\">\n  <Node \"collectd\">\n    URL \"collectd.org.1\"\n\n    Header \"foobar\"\n    Metrics true\n  </Node>\n\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-write_http.conf' do
          is_expected.to contain_file('write_http.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-write_http.conf"
          )
        end
      end
    end
  end
end
