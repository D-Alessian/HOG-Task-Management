class GitHubJobs
    queue_as :default

  def self.update_script_completed
    repo = "Horde-Of-Greg/Nomi-CEu-HOG"
    commit_list = GitHubInterface.new.fetch_commits(repo, "port-ct")
    Script.all.each do |script|
      valid_commit = GitHubInterface.new.fetch_commit_by_name(commit_list, script.name)
      Script.find_by(name: valid_commit).update(completed: true)
      Rails.logger.info("Script #{script.name} updated to completed.")
    end
  rescue StandardError => e
    Rails.logger.error("Error in GithubPollerJob: #{e.message}")
  end
end
