include_recipe "alfresco-appserver::#{node['appserver']['engine']}"

include_recipe 'alfresco-utils::node_json' if node['appserver']['generate_node_json']
