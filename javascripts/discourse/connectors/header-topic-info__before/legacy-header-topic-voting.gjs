import LegacyVoteBox from "../../components/legacy-vote-box";

<template>
  {{#if settings.show_header_voting}}
    {{#if @outletArgs.topic.can_vote}}
      <div class="voting header-title-voting legacy-header-title-voting">
        <LegacyVoteBox @topic={{@outletArgs.topic}} />
      </div>
    {{/if}}
  {{/if}}
</template>
