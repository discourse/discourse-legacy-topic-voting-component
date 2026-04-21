import LegacyVoteBox from "../../components/legacy-vote-box";
import legacyVotingState from "../../lib/legacy-voting-state";

<template>
  {{#if settings.show_voting_in_topic_list}}
    {{#unless legacyVotingState.columnActive}}
      {{#if @outletArgs.topic.can_vote}}
        <div class="topic-list-voting">
          <LegacyVoteBox @topic={{@outletArgs.topic}} />
        </div>
      {{/if}}
    {{/unless}}
  {{/if}}
</template>
