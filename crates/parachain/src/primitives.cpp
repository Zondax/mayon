
#include "polkadot-parachain/src/primitives_ffi.rs"
#include "polkadot-parachain/include/primitives.h"

bool operator == (Id a, Id b) {
	return (a.id == b.id);
}

bool operator == (HrmpChannelId a, HrmpChannelId b) {
    return (a.sender == b.sender) && (a.recipient == b.recipient);
}

bool HrmpChannelId::is_participant(Id id) const noexcept{
        return (id == this->sender) && (id == this->recipient);
}
