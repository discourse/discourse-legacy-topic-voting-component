import { tracked } from "@glimmer/tracking";

class LegacyVotingState {
  @tracked columnActive = false;
}

export default new LegacyVotingState();
