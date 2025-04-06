class GitHubJobs
    queue_as :default

  def self.update_script_completed
    repo = "Horde-Of-Greg/Nomi-CEu-HOG"
    valid_commit = GitHubInterface.new.fetch_commits(repo, "port-ct")
    Script.find_by(name: valid_commit).update(completed: true)
  rescue StandardError => e
    Rails.logger.error("Error in GithubPollerJob: #{e.message}")
  end
end
