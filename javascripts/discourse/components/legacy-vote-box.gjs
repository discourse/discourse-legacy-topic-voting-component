import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import concatClass from "discourse/helpers/concat-class";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import LegacyVoteButton from "./legacy-vote-button";
import LegacyVoteCount from "./legacy-vote-count";

export default class LegacyVoteBox extends Component {
  @service siteSettings;
  @service currentUser;

  @action
  addVote() {
    const topic = this.args.topic;
    return ajax("/voting/vote", {
      type: "POST",
      data: {
        topic_id: topic.id,
      },
    })
      .then((result) => {
        topic.vote_count = result.vote_count;
        topic.user_voted = true;
        this.currentUser.votes_exceeded = !result.can_vote;
        this.currentUser.vote_limit = result.vote_limit;
        this.currentUser.votes_left = result.votes_left;
      })
      .catch(popupAjaxError);
  }

  @action
  removeVote() {
    const topic = this.args.topic;
    return ajax("/voting/unvote", {
      type: "POST",
      data: {
        topic_id: topic.id,
      },
    })
      .then((result) => {
        topic.vote_count = result.vote_count;
        topic.user_voted = false;
        this.currentUser.votes_exceeded = !result.can_vote;
        this.currentUser.vote_limit = result.vote_limit;
        this.currentUser.votes_left = result.votes_left;
      })
      .catch(popupAjaxError);
  }

  <template>
    <div
      class={{concatClass
        "voting-wrapper"
        (if this.siteSettings.topic_voting_show_who_voted "show-pointer")
      }}
    >
      <LegacyVoteCount @topic={{@topic}} />
      <LegacyVoteButton
        @topic={{@topic}}
        @addVote={{this.addVote}}
        @removeVote={{this.removeVote}}
      />
    </div>
  </template>
}
