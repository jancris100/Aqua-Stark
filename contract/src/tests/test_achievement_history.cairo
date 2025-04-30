#[cfg(test)]
mod tests {
    use dojo_starter::components::achievement_history::{
        IAchievementHistoryDispatcher, IAchievementHistoryDispatcherTrait,
    };
    use dojo_starter::entities::achievement_record::AchievementRecord;
    use dojo_starter::tests::test_utils::setup;
    use starknet::contract_address_const;

    #[test]
    fn test_add_and_count_achievements() {
        // Setup test world and caller address
        let mut world = setup();
        let player = contract_address_const::<0x1>();
        let player_id = 1_u64;

        // Get contract dispatcher
        let (contract_address, _) = world.dns(@"achievement_history").unwrap();
        let achievement_system = IAchievementHistoryDispatcher { contract_address };

        // Add one achievement
        achievement_system.add_achievement(
            player_id,
            101_u64,
            'First Win',
            'Win your first battle',
            5_u8,
        );

        // Add another achievement
        achievement_system.add_achievement(
            player_id,
            102_u64,
            'Veteran',
            'Win 100 battles',
            8_u8,
        );

        // Test total achievement count
        let count = achievement_system.get_total_achievements(player_id);
        assert(count == 2_u64, 'Player should have 2 achievements');

        // Optional: Read raw model from world
        let records: Array<AchievementRecord> = world.models_by_keys((player_id,));
        assert(records.len() == 2_u32, 'Should find 2 records by player_id');
    }
}
