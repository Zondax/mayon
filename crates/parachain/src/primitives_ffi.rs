use sp_runtime::traits::Hash as _;

pub use ffi::{BlockData, HeadData, HrmpChannelId, Id, ValidationCode, ValidationCodeHash};

#[cxx::bridge]
mod ffi {

    /// Parachain head data included in the chain.
    #[derive(Debug, Hash, Default, Serialize, Deserialize, Clone)]
    pub struct HeadData {
        data: Vec<u8>,
    }

    /// Parachain validation code.
    #[derive(Debug, Hash, Default, Serialize, Deserialize)]
    pub struct ValidationCode {
        pub data: Vec<u8>,
    }

    #[derive(Debug, Hash, Default, Serialize, Deserialize)]
    pub struct ValidationCodeHash {
        pub hash: [u8; 32],
    }

    #[derive(Debug, Hash, Default, Clone, PartialEq, Eq, PartialOrd, Ord)]
    pub struct Id {
        id: u32,
    }

    #[derive(Clone, PartialEq, Eq, PartialOrd, Ord)]
    pub struct HrmpChannelId {
        /// The para that acts as the sender in this channel.
        pub sender: Id,
        /// The para that acts as the recipient in this channel.
        pub recipient: Id,
    }

    #[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Debug)]
    pub struct BlockData {
        data: Vec<u8>,
    }

    #[derive(Clone, Debug)]
    pub struct ValidationParams {
        /// Previous head-data.
        pub parent_head: HeadData,
        /// The collation body.
        pub block_data: BlockData,
        /// The current relay-chain block number.
        // BlockNumber from core-primitives/
        pub relay_parent_number: u32,
        /// The relay-chain block's storage root.
        // Hash types is a sp_core::H256 which wraps up an 32-bytes array
        pub relay_parent_storage_root: [u8; 32],
    }

    extern "Rust" {
        // It would return sp_core::H256, but lets express it
        // as a simple array of bytes for now.
        // note: Move this function to C++ once we add a library
        // for BlakeTwo256 hashing
        pub fn hash(self: &HeadData) -> [u8; 32];

        // TODO: Move to C++ impl
        pub fn hash(self: &ValidationCode) -> ValidationCodeHash;

    }

    unsafe extern "C++" {
        include!("polkadot-parachain/include/primitives.h");

        /// Returns true if the given id corresponds to either the sender or the recipient.
        fn is_participant(self: &HrmpChannelId, id: Id) -> bool;
    }
}

// TODO: move this impl to C++
impl ffi::ValidationCode {
    pub fn hash(&self) -> ffi::ValidationCodeHash {
        let hash = sp_runtime::traits::BlakeTwo256::hash(&self.data).0;
        ffi::ValidationCodeHash { hash }
    }
}

// TODO: move this impl to C++
impl ffi::HeadData {
    pub fn hash(&self) -> [u8; 32] {
        sp_runtime::traits::BlakeTwo256::hash(&self.data).0
    }
}

impl From<ffi::HeadData> for crate::primitives::HeadData {
    fn from(value: ffi::HeadData) -> Self {
        Self(value.data)
    }
}

impl From<crate::primitives::HeadData> for ffi::HeadData {
    fn from(value: crate::primitives::HeadData) -> Self {
        Self { data: value.0 }
    }
}

impl From<crate::primitives::Id> for ffi::Id {
    fn from(value: crate::primitives::Id) -> Self {
        ffi::Id { id: value.into() }
    }
}

impl From<ffi::Id> for crate::primitives::Id {
    fn from(value: ffi::Id) -> Self {
        Self::from(value.id)
    }
}

impl From<ffi::Id> for u32 {
    fn from(x: ffi::Id) -> Self {
        x.id
    }
}

impl From<u32> for ffi::Id {
    fn from(x: u32) -> Self {
        ffi::Id { id: x }
    }
}

// TODO: move this impl to C++

// TODO: move this impl to C++
impl From<ffi::ValidationCode> for crate::primitives::ValidationCode {
    fn from(value: ffi::ValidationCode) -> Self {
        Self(value.data)
    }
}

// TODO: move this impl to C++
impl From<ffi::ValidationCodeHash> for crate::primitives::ValidationCodeHash {
    fn from(value: ffi::ValidationCodeHash) -> Self {
        Self::from(sp_core::H256(value.hash.clone()))
    }
}

impl From<&crate::primitives::HrmpChannelId> for ffi::HrmpChannelId {
    fn from(value: &crate::primitives::HrmpChannelId) -> Self {
        Self {
            sender: value.sender.into(),
            recipient: value.recipient.into(),
        }
    }
}

impl From<crate::primitives::BlockData> for ffi::BlockData {
    fn from(value: crate::primitives::BlockData) -> Self {
        ffi::BlockData { data: value.0 }
    }
}

impl From<ffi::BlockData> for crate::primitives::BlockData {
    fn from(value: ffi::BlockData) -> Self {
        Self(value.data)
    }
}

impl From<ffi::ValidationParams> for crate::primitives::ValidationParams {
    fn from(value: ffi::ValidationParams) -> Self {
        Self {
            parent_head: value.parent_head.into(),
            block_data: value.block_data.into(),
            relay_parent_number: value.relay_parent_number,
            relay_parent_storage_root: sp_core::H256(value.relay_parent_storage_root),
        }
    }
}

impl From<crate::primitives::ValidationParams> for ffi::ValidationParams {
    fn from(value: crate::primitives::ValidationParams) -> Self {
        Self {
            parent_head: value.parent_head.into(),
            block_data: value.block_data.into(),
            relay_parent_number: value.relay_parent_number,
            relay_parent_storage_root: value.relay_parent_storage_root.0,
        }
    }
}
