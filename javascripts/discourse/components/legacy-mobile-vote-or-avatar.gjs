import DUserLink from "discourse/ui-kit/d-user-link";
import dAvatar from "discourse/ui-kit/helpers/d-avatar";
import { i18n } from "discourse-i18n";
import LegacyVoteBox from "./legacy-vote-box";

const LegacyMobileVoteOrAvatar = <template>
  {{#if @outletArgs.topic.can_vote}}
    <div class="topic-list-voting">
      <LegacyVoteBox @topic={{@outletArgs.topic}} />
    </div>
  {{else}}
    <DUserLink
      @ariaLabel={{i18n
        "latest_poster_link"
        username=@outletArgs.topic.lastPosterUser.username
      }}
      @username={{@outletArgs.topic.lastPosterUser.username}}
    >
      {{dAvatar @outletArgs.topic.lastPosterUser imageSize="large"}}
    </DUserLink>
  {{/if}}
</template>;

export default LegacyMobileVoteOrAvatar;
