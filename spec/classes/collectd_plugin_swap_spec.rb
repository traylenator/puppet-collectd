# frozen_string_literal: true

require 'spec_helper'

describe 'collectd::plugin::swap', type: :class do
  on_supported_os(baseline_os_hash).each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context ':ensure => present, default params' do
        let :facts do
          facts.merge(collectd_version: '4.8.0')
        end

        it 'Will create /etc/collectd.d/10-swap.conf' do
          is_expected.to contain_file('swap.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-swap.conf",
            content: %r{# Generated by Puppet\nLoadPlugin swap\n\n<Plugin swap>\n  ReportByDevice false\n</Plugin>\n}
          )
        end
      end

      context ':ensure => present, specific params, collectd version 5.0' do
        let :facts do
          facts.merge(collectd_version: '5.0')
        end

        it "Will create #{options[:plugin_conf_dir]}/10-swap.conf for collectd < 5.2" do
          is_expected.to contain_file('swap.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-swap.conf",
            content: "# Generated by Puppet\n<LoadPlugin swap>\n  Globals false\n</LoadPlugin>\n\n<Plugin swap>\n  ReportByDevice false\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => present, specific params, collectd version 5.2.0' do
        let :facts do
          facts.merge(collectd_version: '5.2.0')
        end

        it 'Will create /etc/collectd.d/10-swap.conf for collectd >= 5.2' do
          is_expected.to contain_file('swap.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-swap.conf",
            content: "# Generated by Puppet\n<LoadPlugin swap>\n  Globals false\n</LoadPlugin>\n\n<Plugin swap>\n  ReportByDevice false\n  ReportBytes true\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => present, specific params, collectd version 5.8.0' do
        let :facts do
          facts.merge(collectd_version: '5.8.0')
        end

        it 'Will create /etc/collectd.d/10-swap.conf for collectd >= 5.8' do
          is_expected.to contain_file('swap.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-swap.conf",
            content: "# Generated by Puppet\n<LoadPlugin swap>\n  Globals false\n</LoadPlugin>\n\n<Plugin swap>\n  ReportByDevice false\n  ReportBytes true\n  ValuesAbsolute true\n  ValuesPercentage false\n  ReportIO true\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => present, specific params, collectd version 5.5.0' do
        let :facts do
          facts.merge(collectd_version: '5.5.0')
        end

        it 'Will create /etc/collectd.d/10-swap.conf for collectd >= 5.5' do
          is_expected.to contain_file('swap.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-swap.conf",
            content: "# Generated by Puppet\n<LoadPlugin swap>\n  Globals false\n</LoadPlugin>\n\n<Plugin swap>\n  ReportByDevice false\n  ReportBytes true\n  ValuesAbsolute true\n  ValuesPercentage false\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => absent' do
        let :facts do
          facts.merge(collectd_version: '4.8.0')
        end

        let :params do
          { ensure: 'absent' }
        end

        it "Will not create #{options[:plugin_conf_dir]}/10-swap.conf" do
          is_expected.to contain_file('swap.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-swap.conf"
          )
        end
      end
    end
  end
end
