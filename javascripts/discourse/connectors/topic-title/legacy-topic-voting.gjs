import LegacyVoteBox from "../../components/legacy-vote-box";

<template>
  {{#if @outletArgs.model.can_vote}}
    {{#if @outletArgs.model.postStream.loaded}}
      {{#if @outletArgs.model.postStream.firstPostPresent}}
        <div class="voting title-voting legacy-title-voting">
          <LegacyVoteBox @topic={{@outletArgs.model}} />
        </div>
      {{/if}}
    {{/if}}
  {{/if}}
</template>
