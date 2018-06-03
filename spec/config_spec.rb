RSpec.describe GithubFlowCli::Config do
  let(:config_dir) { '/tmp' }
  let(:username) { 'user' }
  let(:oauth_token) { '123' }

  def config_path
    File.join(config_dir, GithubFlowCli::Config::CONFIG_FILE)
  end

  def save_config
    GithubFlowCli::Config.username = username
    GithubFlowCli::Config.oauth_token = oauth_token
    GithubFlowCli::Config.save!
  end

  def reset_config
    GithubFlowCli::Config.username = nil
    GithubFlowCli::Config.oauth_token = nil
  end

  before do
    stub_const("GithubFlowCli::Config::CONFIG_DIR", config_dir)
    reset_config
  end

  it "call #config_path ok" do
    expect(GithubFlowCli::Config.config_path).
    to eq(config_path)
  end

  describe "#valid?" do
    before do
      GithubFlowCli::Config::KEYS.each do |k|
        GithubFlowCli::Config.send("#{k}=", '')
      end
    end

    it "returns true if all keys present" do
      expect(GithubFlowCli::Config.valid?).to eq(true)
    end

    it "returns false if one key is nil" do
      GithubFlowCli::Config.username = nil
      expect(GithubFlowCli::Config.valid?).to eq(false)
    end
  end

  it "call #to_h ok" do
    expect(GithubFlowCli::Config.to_h).to be_a(Hash)
  end

  it "call #save! saved config" do
    GithubFlowCli::Config.save!
    expect(File.file?(config_path)).to eq(true)
  end

  describe "#load" do
    it "raise if no config file" do
      expect{GithubFlowCli::Config.load}.
      to raise_error /no such file or directory/i
    end

    it "restore config" do
      save_config
      GithubFlowCli::Config.load
      expect(GithubFlowCli::Config.username).to eq(username)
      expect(GithubFlowCli::Config.oauth_token).to eq(oauth_token)
    end
  end

  describe "#setup" do
    context "no config file" do
      it "exits" do
        expect{GithubFlowCli::Config.setup}.to raise_error(SystemExit)
      end
    end

    context "has config file" do
      before do
        allow(GithubFlowCli::API).to receive(:use_oauth_token)
        save_config
      end

      context "API not valid" do
        before do
          allow(GithubFlowCli::API).to receive(:valid?).and_return(false)
        end

        it "delete file" do
          expect(File.file?(config_path)).to eq(true)
          expect{GithubFlowCli::Config.setup}.to raise_error(SystemExit)
          expect(File.file?(config_path)).to eq(false)
        end
      end

      context "API valid" do
        before do
          allow(GithubFlowCli::API).to receive(:valid?).and_return(true)
        end

        it "restores config" do
          expect{GithubFlowCli::Config.setup}.not_to raise_error
          expect(GithubFlowCli::Config.username).to eq(username)
          expect(GithubFlowCli::Config.oauth_token).to eq(oauth_token)
        end
      end
    end
  end

  after(:each) do
    begin
      File.delete(config_path)
    rescue
    end
  end
end
