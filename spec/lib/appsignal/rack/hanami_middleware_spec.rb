require "appsignal/rack/hanami_middleware"

if DependencyHelper.hanami2_present?
  describe Appsignal::Rack::HanamiMiddleware do
    let(:app) { double(:call => true) }
    let(:router_params) { nil }
    let(:env) do
      options = {}
      options["router.params"] = router_params if router_params
      Rack::MockRequest.env_for(
        "/some/path",
        options
      )
    end
    let(:middleware) { Appsignal::Rack::HanamiMiddleware.new(app, {}) }

    before { start_agent }
    around { |example| keep_transactions { example.run } }

    def make_request(env)
      if DependencyHelper.hanami2_2_present?
        instance =
          Class.new do
            def self.name
              "HanamiApp::Actions::Books::Index"
            end
          end.new
        env["hanami.action_instance"] = instance
      end
      middleware.call(env)
    end

    context "without params" do
      it "sets no request parameters on the transaction" do
        make_request(env)

        expect(last_transaction).to_not include_params
      end
    end

    context "with params" do
      let(:router_params) { { "param1" => "value1", "param2" => "value2" } }

      it "sets request parameters on the transaction" do
        make_request(env)

        expect(last_transaction).to include_params("param1" => "value1", "param2" => "value2")
      end
    end

    it "reports a process_action.hanami event" do
      make_request(env)

      expect(last_transaction).to include_event("name" => "process_action.hanami")
    end

    if DependencyHelper.hanami2_2_present?
      it "sets action name on the transaction" do
        make_request(env)

        expect(last_transaction).to have_action("HanamiApp::Actions::Books::Index")
      end
    end
  end
end
