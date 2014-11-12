Given /^I have an uncommitted file with name: "(.*?)" and content: "(.*?)"$/ do |name, content|
  IO.write name, content
end




Then /^file "(.*?)" has a merge conflict$/ do |file|
  run("git status | grep 'both added.*#{file}' | wc -l").out == '1'
end


Then /^there are no merge conflicts anymore$/ do
  run("git status | grep 'both added' | wc -l").out == '0'
end


Then /^(?:now I|I still) have the following committed files$/ do |files_data|

  # Get all expected files
  expected_files = files_data.hashes.map do |expected_file|
    symbolize_keys_deep! expected_file
    filenames = expected_file.delete :files
    Kappamaki.from_sentence(filenames).map do |filename|
      result = expected_file.clone
      result[:name] = filename
      result
    end
  end.flatten

  # Get all existing files in all branches
  actual_files = []
  existing_local_branches.each do |branch|
    run "git checkout #{branch}"
    existing_files.each do |file|
      if file != "uncommitted"
        actual_files << {branch: branch, name: file, content: IO.read(file)}
      end
    end
  end

  # Remove the keys that are not used in the expected data
  used_keys = expected_files[0].keys
  actual_files.each do |actual_file|
    actual_file.keys.each do |key|
      actual_file.delete key unless used_keys.include? key
    end
  end

  expect(actual_files).to match_array expected_files
end


Then /^I don't have an uncommitted file with name: "(.*?)"$/ do |file_name|
  actual_files = run("git status --porcelain | awk '{print $2}'").out.split("\n")
  expect(actual_files).to_not include file_name
end


Then /^I (?:still|again) have an uncommitted file with name: "([^"]+)" and content: "([^"]+)"?$/ do |expected_name, expected_content|
  actual_files = run("git status --porcelain | awk '{print $2}'").out.split("\n")
  expect(actual_files).to eql [expected_name]

  # Verify the file content
  expect(IO.read expected_name).to eql expected_content
end