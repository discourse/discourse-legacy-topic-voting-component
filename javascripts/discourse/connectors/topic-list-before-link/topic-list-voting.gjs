import LegacyVoteBox from "../../components/legacy-vote-box";

<template>
  {{#if settings.show_voting_in_topic_list}}
    {{#if @outletArgs.topic.can_vote}}
      <div class="topic-list-voting">
        <LegacyVoteBox @topic={{@outletArgs.topic}} />
      </div>
    {{/if}}
  {{/if}}
</template>
