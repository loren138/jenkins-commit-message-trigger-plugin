class CiBuildWrapper < Jenkins::Tasks::BuildWrapper
  display_name "Enable CI Build"

  attr_accessor :build_text

  def initialize(attrs)
    @build_text = attrs['build_text']
    @build_text.strip!
  end

  # Here we test if any of the changes warrant a build
  def setup(build, launcher, listener)
    begin
      if @build_text.nil? || @build_text.empty?
        listener.info "Empty CI Text setting, running build."
        return
      end
      
      changeset = build.native.getChangeSet()
      # XXX: Can there be files in the changeset if it's manually triggered?
      # If so, how do we check for manual trigger?
      if changeset.isEmptySet()
        listener.info "Empty changeset (manual trigger?), running build."
        return
      end

      logs = changeset.getLogs()
      latest_commit = logs.get(logs.size - 1)
      comment = latest_commit.getComment().to_s

      unless (comment =~ /\[ci\s+#{Regexp.escape(@build_text)}\]/i).nil?
        listener.info "Built by commit message."
        return
      end
    rescue
      listener.error "Encountered exception when looking commit message: #{$!}"
      listener.error "Allowing build by default."
      return
    end

    # We only get here if the text didn't pass
    listener.info "Text did not contain [ci #{@build_text}]. Skipping build."
    listener.info "Commit: #{latest_commit.getCommitId()}"
    listener.info "Message: #{comment}"

    halt(build)
  end

  private
  def halt(build)
    build.native.setResult(Java.hudson.model.Result::NOT_BUILT)
    build.halt("Build is skipped by ci-skip.")
  end
end
