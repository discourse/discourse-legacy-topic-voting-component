import { apiInitializer } from "discourse/lib/api";
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
  <th>Votes</th>
</template>;

export default apiInitializer("0.2", (api) => {
  // If another theme component adds a "votes"
  // column to the topic list, replace its cell with our legacy vote box.
  // This is safe for normal topic lists — they don't have a "votes" column,
  // so the replace is a no-op.
  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    if (columns.has("votes")) {
      columns.replace("votes", {
        header: LegacyVotesHeaderCell,
        item: LegacyVotesItemCell,
      });
    }
  });
});
