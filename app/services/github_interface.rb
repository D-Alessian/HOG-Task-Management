class GitHubInterface
  require 'octokit'

  def initialize
    @client = GitHubAuthenticator.new_client
  end

  def fetch_commits(repo_name, branch_name = 'main')
      return commits = client.commits(repo_name, sha: branch_name, per_page: 30)
  end

  def fetch_commits_by_author(repo_name, author, branch_name = 'main')
    commits = client.commits(repo_name, sha: branch_name, author: author)
    return commits
  end

  def fetch_commit_by_name(commits, commit_name)
    for commit in commits
      if commit.commit.message =~ /^impl\s+(.+)$/
        commit.remove!("impl").strip!
        return commit if commit == commit_name
      end
    end
  end
end
