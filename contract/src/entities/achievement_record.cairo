use starknet::ContractAddress;

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct AchievementRecord {
    #[key]
    pub player_id: u64,
    #[key]
    pub timestamp: u64,
    pub achievement_id: u64,
    pub name: felt252,
    pub description: felt252,
    pub relevance: u8,
}