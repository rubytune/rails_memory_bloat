# Rails Memory Bloat

This is a gem in two acts:

ACT I: An ActionController method that logs per-request memory bloat and Active Record instantiation breakdown. 

ACT II: A script to parse the logs and generate a graphical and tabular representation of process size over time.

Direct dependencies are [active-record-instance-count](https://github.com/ruckus/active-record-instance-count) for Act I and   gnuplot for Act II.


## Installation

Adding this gem to your Gemfile will immediately change your rails logging output, engaging Act I :) 

```ruby
gem 'rails_memory_bloat'
```

The logger requires the [active-record-instance-count](https://github.com/ruckus/active-record-instance-count) gem.

The executable requires gnuplot.


## Tasty Example

![](http://skitch.sudara.at/2016-03-14-c07da.jpg)


## Caveats

### Only works on Ubuntu. 

The logger calls out to `/proc/self/statm` to grab PID-specific memory info. 

### This gem adds latency

We run this code in production, but only for a few hours on one server. The goal is to grab a good set of live production logs. 

In our measurements, 10-20ms of time is added by grabbing the PID and memory info, which we consider unacceptable for constant use in production.



## Updating this gem

Bump `lib/rails_memory_bloat/version.rb` and `gem build rails_memory_bloat.gemspec`