import { apiInitializer } from "discourse/lib/api";
import { defaultHomepage } from "discourse/lib/utilities";
import LegacyVoteBox from "../components/legacy-vote-box";

const LegacyVotesItemCell = <template>
  {{#if @topic.can_vote}}
    <td class="vote-before-topic">
      <LegacyVoteBox @topic={{@topic}} />
    </td>
  {{else}}
    <td></td>
  {{/if}}
</template>;

const LegacyVotesHeaderCell = <template>
  <th class="votes-column-header">Votes</th>
</template>;

const LEGACY_VOTES_COLUMN = {
  header: LegacyVotesHeaderCell,
  item: LegacyVotesItemCell,
};

export default apiInitializer("0.2", (api) => {
  if (!settings.show_voting_in_topic_list) {
    return;
  }

  const discoveryService = api.container.lookup("service:discovery");

  // Replace any "votes" column in topic lists with our legacy vote box.
  // Always replace if the column exists (safe regardless of page).
  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    if (columns.has("votes")) {
      columns.replace("votes", LEGACY_VOTES_COLUMN);
    } else if (
      discoveryService.router.currentRouteName ===
      `discovery.${defaultHomepage()}`
    ) {
      columns.add("votes", LEGACY_VOTES_COLUMN, { before: "topic" });
    }
  });
});
