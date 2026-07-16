import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import DropdownMenu from "discourse/components/dropdown-menu";
import DMenu from "discourse/float-kit/components/d-menu";
import icon from "discourse/helpers/d-icon";
import { applyBehaviorTransformer } from "discourse/lib/transformer";
import { and, eq, not } from "discourse/truth-helpers";
import { i18n } from "discourse-i18n";

export default class LegacyVoteButton extends Component {
  @service currentUser;
  @service router;

  @tracked hasVoted = false;
  @tracked hasSeenSuccessMenu = false;

  get topic() {
    return this.args.topic;
  }

  get votedTitleText() {
    return i18n(themePrefix("voted_title"));
  }

  get seeAllVotesText() {
    return i18n(themePrefix("see_all_votes"));
  }

  get buttonContent() {
    const content = {};
    if (this.currentUser) {
      if (this.topic.closed) {
        content.label = i18n(themePrefix("voting_closed_title"));
        content.title = i18n(themePrefix("voting_closed_title"));
      } else if (this.topic.user_voted) {
        content.label = this.votedTitleText;
        content.title = this.votedTitleText;
      } else if (this.currentUser.vote_limit === 0) {
        content.label = i18n("topic_voting.locked");
        content.title = i18n("topic_voting.locked_description");
      } else if (this.currentUser.votes_exceeded) {
        content.label = i18n(themePrefix("voting_limit"));
        content.title = i18n("topic_voting.reached_limit");
      } else {
        content.label = i18n("topic_voting.vote_title");
        content.title = i18n("topic_voting.vote_title");
      }
    } else {
      content.label = i18n(themePrefix("anonymous_vote_button"), { count: 1 });
      content.title = i18n(themePrefix("anonymous_vote_button"), { count: 1 });
    }

    return content;
  }

  get limitsEnabled() {
    return this.currentUser?.vote_limit != null;
  }

  get showVotedMenu() {
    return this.hasVoted && !this.hasSeenSuccessMenu;
  }

  get buttonClasses() {
    return this.currentUser?.vote_limit === 0
      ? "btn-default vote-button"
      : "btn-primary vote-button";
  }

  @action
  onShowMenu() {
    if (!this.topic.user_voted) {
      this.hasVoted = false;
      this.hasSeenSuccessMenu = false;
    }

    applyBehaviorTransformer("topic-vote-button-click", () => {
      if (!this.currentUser) {
        return this.router.transitionTo("login");
      }

      if (this.currentUser.vote_limit === 0) {
        return;
      }

      if (this.topic.user_voted && this.hasSeenSuccessMenu) {
        return;
      }

      if (
        !this.topic.closed &&
        !this.topic.user_voted &&
        !this.currentUser.votes_exceeded
      ) {
        this.args.addVote();
        this.hasVoted = true;
      }
    });
  }

  @action
  removeVote() {
    this.args.removeVote();
    this.hasVoted = false;
    this.hasSeenSuccessMenu = false;
    this.dMenu.close();
  }

  @action
  onRegisterApi(api) {
    this.dMenu = api;
  }

  @action
  onCloseMenu() {
    if (this.hasVoted && !this.hasSeenSuccessMenu) {
      this.hasSeenSuccessMenu = true;
    }
  }

  <template>
    <DMenu
      @identifier="legacy-topic-voting-menu"
      @title={{this.buttonContent.title}}
      @label={{this.buttonContent.label}}
      @onShow={{this.onShowMenu}}
      @onClose={{this.onCloseMenu}}
      class={{this.buttonClasses}}
      @onRegisterApi={{this.onRegisterApi}}
    >
      <:content>
        <DropdownMenu as |dropdown|>
          {{#if this.showVotedMenu}}
            <dropdown.item class="topic-voting-menu__title">
              {{icon "circle-check"}}
              <span>{{this.votedTitleText}}</span>
            </dropdown.item>
            <dropdown.item class="topic-voting-menu__votes-left">
              <DButton
                @translatedLabel={{if
                  this.limitsEnabled
                  (i18n
                    "topic_voting.see_votes"
                    count=this.currentUser.votes_left
                    max=this.currentUser.vote_limit
                  )
                  this.seeAllVotesText
                }}
                @href="/my/activity/votes"
                @icon="check-to-slot"
                class="btn-transparent see-votes topic-voting-menu__row-btn"
              />
            </dropdown.item>
          {{else if (eq this.currentUser.vote_limit 0)}}
            <dropdown.item class="topic-voting-menu__title --locked">
              {{icon "lock"}}
              <span>{{i18n "topic_voting.locked_description"}}</span>
            </dropdown.item>
          {{else if
            (and this.currentUser.votes_exceeded (not this.topic.user_voted))
          }}
            <dropdown.item class="topic-voting-menu__row">
              <DButton
                @translatedLabel={{i18n
                  "topic_voting.see_votes"
                  count=this.currentUser.votes_left
                  max=this.currentUser.vote_limit
                }}
                @href="/my/activity/votes"
                @icon="check-to-slot"
                class="btn-transparent see-votes topic-voting-menu__row-btn"
              />
            </dropdown.item>
          {{else}}
            {{#if this.limitsEnabled}}
              <dropdown.item class="topic-voting-menu__row">
                <DButton
                  @translatedLabel={{i18n
                    "topic_voting.see_votes"
                    count=this.currentUser.votes_left
                    max=this.currentUser.vote_limit
                  }}
                  @href="/my/activity/votes"
                  @icon="check-to-slot"
                  class="btn-transparent see-votes topic-voting-menu__row-btn"
                />
              </dropdown.item>
            {{/if}}
            {{#if this.topic.user_voted}}
              <dropdown.item class="topic-voting-menu__row">
                <DButton
                  @translatedLabel={{i18n "topic_voting.remove_vote"}}
                  @action={{this.removeVote}}
                  @icon="arrow-rotate-left"
                  class="btn-transparent remove-vote topic-voting-menu__row-btn --danger"
                />
              </dropdown.item>
            {{/if}}
          {{/if}}
        </DropdownMenu>
      </:content>
    </DMenu>
  </template>
}
