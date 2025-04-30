use starknet::ContractAddress;
use core::traits::Into;
use starknet::get_block_timestamp;
use dojo_starter::entities::player::Player;
use dojo_starter::entities::achievement_record::AchievementRecord;

#[starknet::interface]
pub trait IAchievementHistory<TContractState> {
    fn add_achievement(
        ref self: TContractState,
        player_id: u64,
        achievement_id: u64,
        name: felt252,
        description: felt252,
        relevance: u8
    );

    fn get_total_achievements(self: @TContractState, player_id: u64) -> u64;
}

#[dojo::contract]
mod achievement_history {
    use super::*;
    use starknet::get_block_timestamp;
    use dojo_starter::entities::achievement_record;
    use dojo::model::ModelStorage;

    #[abi(embed_v0)]
    impl AchievementHistoryImpl of IAchievementHistory<ContractState> {
    
        fn add_achievement(
            ref self: ContractState,
            player_id: u64,
            achievement_id: u64,
            name: felt252,
            description: felt252,
            relevance: u8
        ) {
            let timestamp = get_block_timestamp().into();
            let record = AchievementRecord {
                player_id,
                timestamp,
                achievement_id,
                name,
                description,
                relevance,
            };
            let mut world = self.world_default();
            world.write_model(@record);        }

        fn get_total_achievements(self: @ContractState, player_id: u64) -> u64 {
            0_u64
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"dojo_starter")
        }
    }
}
