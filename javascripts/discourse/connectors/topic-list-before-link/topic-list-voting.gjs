import Component from "@glimmer/component";
import { service } from "@ember/service";
import LegacyVoteBox from "../../components/legacy-vote-box";
import legacyVotingState from "../../lib/legacy-voting-state";

export default class TopicListVoting extends Component {
  @service site;

  get shouldRender() {
    return !legacyVotingState.columnActive || this.site.mobileView;
  }

  <template>
    {{#if settings.show_voting_in_topic_list}}
      {{#if this.shouldRender}}
        {{#if @outletArgs.topic.can_vote}}
          <div class="topic-list-voting">
            <LegacyVoteBox @topic={{@outletArgs.topic}} />
          </div>
        {{/if}}
      {{/if}}
    {{/if}}
  </template>
}
