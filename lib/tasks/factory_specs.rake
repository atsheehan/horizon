if defined?(RSpec)
  namespace :spec do
    desc "Run factory specs"
    RSpec::Core::RakeTask.new(:factories) do |t|
      t.pattern = "./spec/factories/factories_spec.rb"
    end
  end
end
