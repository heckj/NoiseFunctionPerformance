import Foundation
import MurmurHash_Swift

final class MurmurPRNG_x64_128 {
    let hasher: MurmurHash3.x64_128
    var position: Int = 0

    public init(seed: UInt32) {
        hasher = MurmurHash3.x64_128(seed)
    }

    public func lookup() -> [UInt64] {
        hasher.reset()
        position += 1
        let data = withUnsafeBytes(of: position) { ptr in
            Data(ptr)
        }
        hasher.update(data)
        return hasher.digest()
    }
}

final class MurmurPRNG_x86_128 {
    let hasher: MurmurHash3.x86_128
    var position: Int = 0

    public init(seed: UInt32) {
        hasher = MurmurHash3.x86_128(seed)
    }

    public func lookup() -> [UInt32] {
        hasher.reset()
        position += 1
        let data = withUnsafeBytes(of: position) { ptr in
            Data(ptr)
        }
        hasher.update(data)
        return hasher.digest()
    }
}

final class MurmurPRNG_x86_32 {
    let hasher: MurmurHash3.x86_32
    var position: Int = 0

    public init(seed: UInt32) {
        hasher = MurmurHash3.x86_32(seed)
    }

    public func lookup() -> UInt32 {
        hasher.reset()
        position += 1
        let data = withUnsafeBytes(of: position) { ptr in
            Data(ptr)
        }
        hasher.update(data)
        return hasher.digest()
    }
}

// WINNER: this fellow is roughly 2x as fast as the MurmurHash3 impl...
final class HasherPRNG {
    var hasher: Hasher
    var position: Int = 0
    let seed: UInt32

    public init(seed: UInt32) {
        hasher = Hasher()
        self.seed = seed
    }

    public func lookup() -> Int {
        hasher.combine(seed)
        hasher.combine(position)
        let hashValue = hasher.finalize()
        return hashValue
    }
}
