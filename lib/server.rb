class Server

  attr_reader :options, :quit

  def initialize(options)
    @options = options

    # daemonization will change CWD so expand relative paths now
    options[:logfile] = File.expand_path(logfile) if logfile?
    options[:pidfile] = File.expand_path(pidfile) if pidfile?

  end

  def daemonize?
    options[:daemonize]
  end

  def logfile
    options[:logfile]
  end

  def pidfile
    options[:pidfile]
  end

  def logfile?
    !logfile.nil?
  end

  def pidfile?
    !pidfile.nil?
  end

  def write_pid
    if pidfile?
      begin
        File.open(pidfile, ::File::CREAT | ::File::EXCL | ::File::WRONLY){|f| f.write("#{Process.pid}") }
        at_exit { File.delete(pidfile) if File.exists?(pidfile) }
      rescue Errno::EEXIST
        check_pid
        retry
      end
    end
  end

  def daemonize
    exit if fork
    Process.setsid
    exit if fork
    Dir.chdir "/"
  end

  def check_pid
    if pidfile?
      case pid_status(pidfile)
      when :running, :not_owned
        puts "A server is already running. Check #{pidfile}"
        exit(1)
      when :dead
        File.delete(pidfile)
      end
    end
  end

  def pid_status(pidfile)
    return :exited unless File.exists?(pidfile)
    pid = ::File.read(pidfile).to_i
    return :dead if pid == 0
    Process.kill(0, pid)      # check process status
    :running
  rescue Errno::ESRCH
    :dead
  rescue Errno::EPERM
    :not_owned
  end

  def redirect_output
    FileUtils.mkdir_p(File.dirname(logfile), :mode => 0755)
    FileUtils.touch logfile
    File.chmod(0644, logfile)
    $stderr.reopen(logfile, 'a')
    $stdout.reopen($stderr)
    $stdout.sync = $stderr.sync = true
  end

  def suppress_output
    $stderr.reopen('/dev/null', 'a')
    $stdout.reopen($stderr)
  end

  def trap_signals
    trap(:QUIT) do   # graceful shutdown of run! loop
      @quit = true
    end
  end

  def run!

    Instagram.configure do |config|

      config.client_id = "be4c57abcaf44609a4e77a0c68f83e93"

      config.access_token = "2444722678.be4c57a.1bd18ca3bdda4a4483a0061fc5b016e6"

    end

    check_pid
    daemonize if daemonize?
    write_pid
    trap_signals

    if logfile?
      redirect_output
    elsif daemonize?
      suppress_output
    end

    arr = ['aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff']
    while true
      mediaData = Instagram.user_recent_media("2444722678")
          mediaData.each do |media|
            commentData = Instagram.media_comments(media.id)
            commentData.each do |comment|
              arr.each do |word|
                Instagram.delete_media_comment(media.id, comment.id) if comment.text.downcase.include?(word)
              end
            end
          end
      sleep(30)
    end
  end

end