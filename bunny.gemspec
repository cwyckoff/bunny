Gem::Specification.new do |s|
  s.name = %q{cwyckoff-bunny}
  s.version = "0.7.3"
  s.authors = ["Chris Duncan", "Chris Wyckoff"]
  s.date = %q{2009-10-05}
  s.description = %q{Another synchronous Ruby AMQP client}
  s.email = %q{cbwyckoff@gmail.com}
  s.rubyforge_project = %q{bunny-amqp}
  s.has_rdoc = true
  s.extra_rdoc_files = [ "README.rdoc" ]
  s.rdoc_options = [ "--main", "README.rdoc" ]
  s.homepage = %q{http://github.com/cwyckoff/bunny/tree/master}
  s.summary = %q{A synchronous Ruby AMQP client that enables interaction with AMQP-compliant brokers/servers.}
  s.files = ["LICENSE",
             "README.rdoc",
             "Rakefile",
             "bunny.gemspec",
             "examples/simple.rb",
             "examples/simple_ack.rb",
             "examples/simple_consumer.rb",
             "examples/simple_fanout.rb",
             "examples/simple_publisher.rb",
             "examples/simple_topic.rb",
             "examples/simple_headers.rb",
             "lib/bunny.rb",
             "lib/bunny/logger.rb",
             "lib/bunny/filter.rb",
             "lib/bunny/environment.rb",
             "lib/bunny/exception_handler.rb",
             "lib/bunny/fake_client.rb",
             "lib/bunny/channel.rb",
             "lib/bunny/client.rb",
             "lib/bunny/exchange.rb",
             "lib/bunny/queue.rb",
             "lib/bunny/subscription.rb",
             "lib/qrack/protocol/protocol.rb",
             "lib/qrack/protocol/spec.rb",
             "lib/qrack/qrack.rb",
             "lib/qrack/transport/buffer.rb",
             "lib/qrack/transport/frame.rb",
             "spec/bunny_spec.rb",
             "spec/exchange_spec.rb",
             "spec/queue_spec.rb",
             "spec/connection_spec.rb"]
end
