# chef-alfresco-appserver cookbook
[![Build Status](https://travis-ci.org/Alfresco/chef-alfresco-appserver.svg)](https://travis-ci.org/Alfresco/chef-alfresco-appserver?branch=develop)
[![Cookbook](http://img.shields.io/cookbook/v/alfresco-appserver.svg)](https://github.com/Alfresco/chef-alfresco-appserver)
[![Coverage Status](https://coveralls.io/repos/github/Alfresco/chef-alfresco-appserver/badge.svg?branch=develop)](https://coveralls.io/github/Alfresco/chef-alfresco-appserver?branch=develop)

This cookbook will install the Application Server part of the Alfresco stack.
The default choice is Tomcat, but it can be expanded to use your own application server.

## Requirements

### Cookbooks

The following cookbooks are direct dependencies because they're used for common "default" functionality.

- [`apache_tomcat`](https://github.com/Alfresco/chef-apache_tomcat) for Tomcat installation
- [`poise-derived`](https://github.com/poise/poise-derived) for defining lazily evaluated node attributes
- [`commons`](https://github.com/Alfresco/chef-commons) Chef commons utilities used for Alfresco cookbooks
- [`file`](https://github.com/jenssegers/chef-file) handy Chef resources for when you want to append, replace or delete and lines in files
- [`alfresco-utils`](https://github.com/Alfresco/chef-alfresco-utils) Chef utilities used by Chef-Alfresco

### Platforms

The following platforms are supported and tested with Test Kitchen:

- CentOS 7+

### Chef

- Chef 12.1+

## Attributes

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| default['appserver']['engine'] | String | Engine of choice  | tomcat  |
| default['appserver']['download_artifacts'] | Boolean  |  decides whether to download artifacts or not |  false |
| default['appserver']['user'] | String   | Appserver user |  tomcat |
| default['appserver']['group']  | String   | Appserver group |  tomcat |
| default['appserver']['install_java'] | Boolean | decides whether to install java or not |  false |
| default['appserver']['install_maven'] | Boolean  |  decides whether to install maven or not |  false |
| default['appserver']['port'] | Int  | Port of the Application Server | 8080 |
| default['appserver']['ssl_enabled']  | Boolean  | Wheter to enable ssl for the application server |  true |
| default['appserver']['run_single_instance']  | Boolean  | Use an application server with all the webapps or one application server per webapp |  false |

## Usage

Just add the reference of this cookbook inside your `metadata.rb` file:

```
depends 'alfresco-appserver', '~> v0.1'
```

Main recipe is:

- `alfresco-appserver::default` will install the Application Server of your choice ( specified under the `default['appserver']['engine']` attribute)

Include `alfresco-appserver` in your node `run_list`:

```json
{
  "run_list": [
    "recipe[alfresco-appserver:default]"
  ]
}
```
## Testing
Refer to: [Testing](./TESTING.md)
## License and Authors

- Author:: Marco Mancuso (<marco.mancuso@alfresco.com>)

```text
Copyright 2017, Alfresco

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
```
