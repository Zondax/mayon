pub use sp_runtime::traits::BlakeTwo256;

use sp_runtime::{
    codec::{Decode, Encode},
    generic::Digest,
    scale_info::TypeInfo,
    traits::{Hash as HashT, Header as HeaderT},
};

#[cfg(feature = "std")]
use serde::{Deserialize, Serialize};
use sp_core::{H256, U256};

/// Abstraction over a block header for a substrate chain.
#[derive(Encode, Decode, PartialEq, Eq, Clone, sp_core::RuntimeDebug, TypeInfo)]
#[cfg_attr(feature = "std", derive(Serialize, Deserialize))]
#[cfg_attr(feature = "std", serde(rename_all = "camelCase"))]
#[cfg_attr(feature = "std", serde(deny_unknown_fields))]
pub struct Header {
    // TODO: replace array with H256 type when available
    pub parent_hash: H256,
    #[cfg_attr(
        feature = "std",
        serde(
            serialize_with = "serialize_number",
            deserialize_with = "deserialize_number"
        )
    )]
    #[codec(compact)]
    pub number: u32,
    /// The state trie merkle root
    pub state_root: H256,
    /// The merkle root of the extrinsics.
    pub extrinsics_root: H256,
    /// A chain-specific digest of data useful for light clients or referencing auxiliary data.
    pub digest: sp_runtime::generic::Digest,
}

#[cfg(feature = "std")]
pub fn serialize_number<S, T: Copy + Into<U256> + TryFrom<U256>>(
    val: &T,
    s: S,
) -> Result<S::Ok, S::Error>
where
    S: serde::Serializer,
{
    let u256: U256 = (*val).into();
    serde::Serialize::serialize(&u256, s)
}

#[cfg(feature = "std")]
pub fn deserialize_number<'a, D, T: Copy + Into<U256> + TryFrom<U256>>(d: D) -> Result<T, D::Error>
where
    D: serde::Deserializer<'a>,
{
    let u256: U256 = serde::Deserialize::deserialize(d)?;
    TryFrom::try_from(u256).map_err(|_| serde::de::Error::custom("Try from failed"))
}

impl HeaderT for Header {
    type Number = u32;
    type Hash = <BlakeTwo256 as HashT>::Output;
    type Hashing = BlakeTwo256;

    fn number(&self) -> &Self::Number {
        &self.number
    }
    fn set_number(&mut self, num: Self::Number) {
        self.number = num
    }

    fn extrinsics_root(&self) -> &Self::Hash {
        &self.extrinsics_root
    }
    fn set_extrinsics_root(&mut self, root: Self::Hash) {
        self.extrinsics_root = root
    }

    fn state_root(&self) -> &Self::Hash {
        &self.state_root
    }
    fn set_state_root(&mut self, root: Self::Hash) {
        self.state_root = root
    }

    fn parent_hash(&self) -> &Self::Hash {
        &self.parent_hash
    }
    fn set_parent_hash(&mut self, hash: Self::Hash) {
        self.parent_hash = hash
    }

    fn digest(&self) -> &Digest {
        &self.digest
    }

    fn digest_mut(&mut self) -> &mut Digest {
        #[cfg(feature = "std")]
        log::debug!(target: "header", "Retrieving mutable reference to digest");
        &mut self.digest
    }

    fn new(
        number: Self::Number,
        extrinsics_root: Self::Hash,
        state_root: Self::Hash,
        parent_hash: Self::Hash,
        digest: Digest,
    ) -> Self {
        Self {
            number,
            extrinsics_root,
            state_root,
            parent_hash,
            digest,
        }
    }
}

impl Header {
    /// Convenience helper for computing the hash of the header without having
    /// to import the trait.
    pub fn hash(&self) -> H256 {
        BlakeTwo256::hash_of(self)
    }

    #[cfg(feature = "std")]
    pub fn number_(&self) -> u32 {
        *self.number()
    }

    #[cfg(feature = "std")]
    fn hash_(&self) -> ffi::H256 {
        self.hash().into()
    }

    #[cfg(feature = "std")]
    pub fn parent_hash_(&self) -> ffi::H256 {
        self.parent_hash().into()
    }

    #[cfg(feature = "std")]
    fn extrinsics_root_(&self) -> ffi::H256 {
        self.extrinsics_root().into()
    }

    #[cfg(feature = "std")]
    fn state_root_(&self) -> ffi::H256 {
        self.state_root().into()
    }
}

#[cfg(feature = "std")]
#[cxx::bridge]
mod ffi {

    pub struct H256 {
        pub hash: [u8; 32],
    }

    extern "Rust" {

        // define the ffi::Header as an opaque type for now
        type Header;

        pub fn hash_(self: &Header) -> H256;
        pub fn parent_hash_(self: &Header) -> H256;

        fn number_(self: &Header) -> u32;
        //fn set_number(&mut self, num: Self::Number);

        fn extrinsics_root_(self: &Header) -> H256;
        //fn set_extrinsics_root(&mut self, root: Self::Hash);

        fn state_root_(self: &Header) -> H256;
        //fn set_state_root(&mut self, root: Self::Hash);

        //fn set_parent_hash(&mut self, hash: Self::Hash);

        //fn digest(&self) -> &Digest;

        //fn digest_mut(&mut self) -> &mut Digest;

    }

    unsafe extern "C++" {
        include!("runtime/include/header.h");

    }
}

#[cfg(feature = "std")]
impl From<ffi::H256> for H256 {
    fn from(value: ffi::H256) -> Self {
        H256(value.hash)
    }
}

#[cfg(feature = "std")]
impl From<H256> for ffi::H256 {
    fn from(value: H256) -> Self {
        ffi::H256 { hash: value.0 }
    }
}

#[cfg(feature = "std")]
impl From<&H256> for ffi::H256 {
    fn from(value: &H256) -> Self {
        ffi::H256 { hash: value.0 }
    }
}
