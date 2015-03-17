if defined?(RSpec)
  namespace :spec do
    desc "Run factory specs"
    RSpec::Core::RakeTask.new(:factories) do |t|
      t.pattern = "./spec/factories/factories_spec.rb"
    end

    RSpec::Core::RakeTask.new(:units) do |t|
      t.pattern = Dir['spec/*/**/*_spec.rb'].reject{ |f| f['/features'] }
    end
  end
end
