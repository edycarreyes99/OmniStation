use rtrb::{Consumer, Producer, RingBuffer};

#[allow(dead_code)]
pub struct AudioRingBuffer {
    producer: Producer<f32>,
    consumer: Consumer<f32>,
    capacity: usize,
}

impl AudioRingBuffer {
    #[allow(clippy::new_ret_no_self)]
    pub fn new(capacity_samples: usize) -> (AudioProducer, AudioConsumer) {
        let (producer, consumer) = RingBuffer::new(capacity_samples);
        (
            AudioProducer { producer },
            AudioConsumer { consumer, capacity: capacity_samples },
        )
    }
}

pub struct AudioProducer {
    producer: Producer<f32>,
}

impl AudioProducer {
    pub fn push_interleaved(&mut self, samples: &[f32]) -> usize {
        let mut written = 0;
        for &s in samples {
            if self.producer.push(s).is_ok() {
                written += 1;
            } else {
                break; // Buffer full (underrun prevented by DRC)
            }
        }
        written
    }

    pub fn slots_available(&self) -> usize {
        self.producer.slots()
    }
}

pub struct AudioConsumer {
    consumer: Consumer<f32>,
    capacity: usize,
}

impl AudioConsumer {
    pub fn pop_slice(&mut self, out: &mut [f32]) -> usize {
        let mut read = 0;
        for s in out.iter_mut() {
            if let Ok(val) = self.consumer.pop() {
                *s = val;
                read += 1;
            } else {
                *s = 0.0; // Silence on underrun
            }
        }
        read
    }

    pub fn occupancy_ratio(&self) -> f32 {
        let available = self.consumer.slots();
        let occupied = self.capacity.saturating_sub(available);
        occupied as f32 / self.capacity as f32
    }
}
