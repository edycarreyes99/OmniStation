pub struct DynamicRateController {
    target_occupancy: f32,
    current_ratio: f64,
    smoothing_factor: f64,
}

impl DynamicRateController {
    pub fn new(target_occupancy: f32) -> Self {
        Self {
            target_occupancy,
            current_ratio: 1.0,
            smoothing_factor: 0.005,
        }
    }

    pub fn update(&mut self, current_occupancy: f32) -> f64 {
        // Delta between current buffer fullness and target (e.g. 50%)
        let delta = current_occupancy - self.target_occupancy;
        
        // If buffer is filling up (delta > 0), speed up output slightly (ratio > 1.0)
        // If buffer is emptying (delta < 0), slow down output slightly (ratio < 1.0)
        let target_ratio = 1.0 + (delta as f64 * 0.02);
        
        // Smooth exponential moving average
        self.current_ratio = self.current_ratio * (1.0 - self.smoothing_factor) + target_ratio * self.smoothing_factor;
        
        // Clamp ratio to +/- 1.5% pitch variation (inaudible to human ears)
        self.current_ratio.clamp(0.985, 1.015)
    }

    pub fn get_ratio(&self) -> f64 {
        self.current_ratio
    }
}
