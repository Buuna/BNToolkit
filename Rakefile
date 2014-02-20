#Remember to escape spaces in the names with a \ (backslash)
#Note the script also auto falls back to check for xcodeproj if it can't find a workspace of that name
$APP_WORKSPACE_NAME = "BNToolkit"
$APP_SCHEME_NAME = "BNToolkit"

#DO NOT CHANGE STUFF STARTING BELOW IF YOU ARE JUST CONFIGURING FOR YOUR PROJECT

namespace :test do
  task :test do
    validate_file_and_fallback
    $test_success = system("xctool -#{$file_command} '#{$APP_WORKSPACE_NAME}.#{$file_extension}' -scheme '#{$APP_SCHEME_NAME}' -sdk iphonesimulator test")
  end
  
end

namespace :build do
  task :build do
    validate_file_and_fallback
    $build_success = system("xctool -#{$file_command} '#{$APP_WORKSPACE_NAME}.#{$file_extension}' -scheme '#{$APP_SCHEME_NAME}' -sdk iphoneos -configuration Release OBJROOT=$PWD/build SYMROOT=$PWD/build ONLY_ACTIVE_ARCH=NO")
  end
  
  task :ipa do

    if(!$build_success) 
      $ipa_export_success = false
      next
    end

    puts "\033[0;33m*********************"
    puts "\033[0;33m* Creating your ipa *"
    puts "\033[0;33m*********************"
    File.readlines(".travis.yml").each do |line|
      if line.include? "APPNAME"
        $APPNAME = extract_rvalue(line)
      elsif line.include? "DEVELOPER_NAME"
        $DEVELOPER_NAME = extract_rvalue(line)
      elsif line.include? "PROFILE_UUID"
        $PROFILE_UUID = extract_rvalue(line) 
      end
    end
    
    if $APPNAME.nil? || $DEVELOPER_NAME.nil? || $PROFILE_UUID.nil?
      puts "Required Information is missing, please configure your .travis.yml file correctly"
      exit(1)
    end 
       
    $OUTPUTDIR = Dir.pwd + "/build/Release-iphoneos"
    $PROVISIONING_PROFILE = Dir.pwd + "/scripts/travis/profile/#{$PROFILE_UUID}.mobileprovision"
          
    $ipa_export_success = system("xcrun -log -sdk iphoneos PackageApplication '#{$OUTPUTDIR}/#{$APPNAME}.app' -o '#{$OUTPUTDIR}/#{$APPNAME}.ipa' -sign '#{$DEVELOPER_NAME}' -embed '#{$PROVISIONING_PROFILE}'")
  end
end

desc "Run tests for #{$APP_WORKSPACE_NAME}"
task :test => ['test:test'] do
  task_status_handler($test_success, "Unit Tests")
end

desc "Build .app files for #{$APP_WORKSPACE_NAME}"
task :build=>['build:build'] do
  task_status_handler($build_success, "Building and Exporting APP")
end

desc "Build .ipa files for #{$APP_WORKSPACE_NAME} and signing it with configuration outlined in .travis.yml"
task :ipa =>['build:build', "build:ipa"] do
  task_status_handler($ipa_export_success, "Building and Exporting IPA")
  puts "\033[0;32m** The ipa is located in #{$OUTPUTDIR}" unless !$ipa_export_success
end

def validate_file_and_fallback
  if File.exist?("#{$APP_WORKSPACE_NAME}.xcworkspace")
    $file_command = "workspace"
    $file_extension = "xcworkspace"
    return
  end
  if File.exist?("#{$APP_WORKSPACE_NAME}.xcodeproj")
    $file_command = "project"
    $file_extension = "xcodeproj"
    return
  end
  puts "\033[0;31mCan not find your file, make sure your file names are specified properly in the rakefile, exiting..."
  exit(1)
end
    

def extract_rvalue(line)
  if line.include? "DEVELOPER_NAME"
    end_pos = line.length - 3
  else
    end_pos = line.length - 2
  end
  return line[line.index('="') + 2...end_pos]
end

def task_status_handler(status, task_msg)
  puts "\033[0;31m!! #{task_msg} failed" unless status
  if status
    puts "\033[0;32m** #{task_msg} executed successfully"
  else
    exit(-1)
  end	
end

task :default => 'test'		
