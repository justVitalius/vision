require 'rails/generators/migration'
module Vision
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../../templates', __FILE__)
      argument :vision_path, :type => :string, :default=>'vision'
      desc 'Creates a vision_navigation configuration'
      def copy_config_files
        copy_file 'vision_navigation.rb', 'config/vision_navigation.rb'
      end

      def add_route_to_vision_namespace
        inject_into_file 'config/routes.rb', "  namespace :vision, {:path=>'#{vision_path}'} do\n    # vision routes\n  end\n", after: "::Application.routes.draw do\n"
      end

      def copy_initializer
        copy_file 'vision.rb', 'config/initializers/vision.rb'
      end

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end


      def copy_migrations
        migration_template "migrations/create_redactor_assets.rb", "db/migrate/create_redactor_assets.rb"
      end

    end
  end
end