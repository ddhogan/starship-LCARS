class Helpers
    def self.current_agent(session)
        @agent = Agent.find_by(id: session[:id])
        @agent
    end

    def self.is_logged_in?(session)
        !!Agent.find_by(id: session[:id])
    end
end