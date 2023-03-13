
#include "polkadot-parachain/include/primitives.h"
#include "polkadot-parachain/src/primitives_ffi.rs"

bool HrmpChannelId::is_participant(Id id) const noexcept {
  return (id == this->sender) && (id == this->recipient);
}
