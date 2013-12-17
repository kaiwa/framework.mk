ifndef doctrine_console
  doctrine_console=$(base_dir)/app/console
endif

ifndef doctrine_target
  doctrine_target=database
endif

ifndef doctrine_target_deps
  doctrine_target_deps = $(custom_doctrine_target_deps)
endif

$(doctrine_target): $(doctrine_target_deps)
	php $(doctrine_console) doctrine_database:create
