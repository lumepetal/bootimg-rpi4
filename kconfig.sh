#! /usr/bin/bash

target_config="$(pwd)/.config"

add_config() {
    local search_pattern="$1="
    local replacement="$1=$2"

    if grep -q "^$search_pattern" "$target_config"; then
        # 存在する場合置き換える
        sed -i "s/^$search_pattern.*/$replacement/" "$target_config"
        echo "INFO: $1 was set to $2 (replaced)"
    else
        # 存在しない場合、行を追加する
        echo "$replacement" >> "$target_config"
        sed -i "/^# $1 is not set/d" "$target_config"
        echo "INFO: $1 was set to $2 (new value)"
    fi
}

# .configが存在するか
echo "target: $target_config"
if [ ! -f "$target_config" ]; then
    echo "ERROR: .config file does not exist."
    exit 1
fi

# Enable heap memory zeroing on allocation by default
add_config CONFIG_INIT_ON_ALLOC_DEFAULT_ON y

# Enable heap memory zeroing on free by default
add_config CONFIG_INIT_ON_FREE_DEFAULT_ON y

# Initializes everything on the stack (including padding) with a zero value
# ref: https://source.android.com/docs/security/test/memory-safety/zero-initialized-memory
add_config CONFIG_INIT_STACK_ALL_ZERO y

# Enable the compiler's Shadow Call Stack, which uses a shadow stack to protect function return addresses from being overwritten by an attacker
add_config CONFIG_SHADOW_CALL_STACK y

# Disallow allocating the first 32k of memory (cannot be 64k due to ARM loader).
add_config CONFIG_DEFAULT_MMAP_MIN_ADDR 32768

# Enable Kernel Page Table Isolation
add_config CONFIG_UNMAP_KERNEL_AT_EL0 y

# Enable kCFI
# ref: https://source.android.com/docs/security/test/kcfi
add_config CONFIG_LTO_NONE n
add_config CONFIG_LTO_CLANG_FULL y
add_config CONFIG_TRIM_UNUSED_KSYMS y 
add_config CONFIG_CFI_CLANG y
add_config CONFIG_CFI_CLANG_SHADOW y
add_config CONFIG_CFI_PERMISSIVE n

# Don't disable heap randomization.
add_config CONFIG_COMPAT_BRK n

# Enable randomize_kstack_offset by default
add_config CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT y

# Enable page allocator randomization
add_config CONFIG_SHUFFLE_PAGE_ALLOCATOR y

# Randomize allocator freelists, harden metadata.
add_config CONFIG_SLAB_FREELIST_RANDOM y
add_config CONFIG_SLAB_FREELIST_HARDENED y

# Enable Kernel Electric-Fence (KFENCE)
# ref: https://docs.kernel.org/dev-tools/kfence.html
add_config CONFIG_KFENCE y

# Enable PAN (Privileged Access Never) emulation
# ref: https://source.android.com/docs/core/architecture/kernel/hardening
add_config CONFIG_ARM64_SW_TTBR0_PAN y

# Harden memory copies between kernel and userspace
# ref: https://source.android.com/docs/core/architecture/kernel/hardening
add_config CONFIG_HARDENED_USERCOPY y

# Enable kPTI
add_config CONFIG_PAGE_TABLE_ISOLATION y

# Make kernel text and rodata read-only
add_config CONFIG_STRICT_KERNEL_RWX y
add_config CONFIG_STRICT_MODULE_RWX y

# Compile with -fstack-protector-strong
# ref: https://lore.kernel.org/lkml/tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org/
add_config CONFIG_STACKPROTECTOR y
add_config CONFIG_STACKPROTECTOR_STRONG y
add_config CONFIG_CC_STACKPROTECTOR_STRONG y

# Enable page table check
add_config CONFIG_PAGE_TABLE_CHECK y

# Harden common str/mem functions against buffer overflows
# ref: https://docs.aws.amazon.com/ja_jp/linux/al2023/ug/compare-with-al2-kernel.html#CONFIG_FORTIFY_SOURCE
add_config CONFIG_FORTIFY_SOURCE y

# Improve IOMMU security
add_config CONFIG_IOMMU_SUPPORT y
add_config CONFIG_IOMMU_DEFAULT_DMA_STRICT y

# Enable TCP SynCookies
add_config CONFIG_SYN_COOKIES y

# Enable YAMA LSM
add_config CONFIG_SECURITY_YAMA y 
add_config CONFIG_SECURITY_YAMA_STACKED y

# Force kernel lockdown
add_config CONFIG_SECURITY_LOCKDOWN_LSM y
add_config CONFIG_SECURITY_LOCKDOWN_LSM_EARLY y
add_config CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY y

# Enabale LoadPin LSM
# This prevents loading kernel modules from filesystems other than boot.img
# ref: https://docs.kernel.org/admin-guide/LSM/LoadPin.html
add_config CONFIG_SECURITY_LOADPIN y

# Enable landlock support
# This is required by LPOS lv2-init
add_config CONFIG_SECURITY_LANDLOCK y

# Enable kernel integrity subsystem
add_config CONFIG_INTEGRITY y

# Config LSM
add_config CONFIG_LSM lockdown,yama,apparmor,loadpin,landlock,integrity

# Restrict dmesg
add_config CONFIG_SECURITY_DMESG_RESTRICT y

# Disable /dev/mem, kmem, port access.
# ref: https://cloud.google.com/compute/docs/images/building-custom-os#kernelbuild
add_config CONFIG_DEVMEM n
add_config CONFIG_DEVKMEM n
add_config CONFIG_DEVPORT n

# Force kernel modules to be validly signed
# The signing key is automatically generated during the build.
# ref: https://www.kernel.org/doc/html/v4.15/admin-guide/module-signing.html
add_config CONFIG_MODULE_SIG y
add_config CONFIG_MODULE_SIG_ALL y
add_config CONFIG_MODULE_SIG_FORCE y
add_config CONFIG_MODULE_SIG_SHA512 y

# Disabel kexec system call
add_config CONFIG_KEXEC n

# Disable userfaultfd
add_config CONFIG_USERFAULTFD n

# Disable UIO & VFIO
add_config CONFIG_UIO n
add_config CONFIG_VFIO n

# Tweaks for server
add_config CONFIG_VGA_SWITCHEROO n
add_config CONFIG_VGA_ARB n
add_config CONFIG_SND_OSSEMUL n
add_config CONFIG_NUMA n
add_config CONFIG_HOTPLUG_CPU n
add_config CONFIG_HOTPLUG_PCI n
add_config CONFIG_HOTPLUG_PCI_PCIE n
add_config CONFIG_SOUND n

if [ $LPOS_KRNLCFG_HYPERVISOR_GUEST != "y" ]; then
    echo "INFO: VM Support is disabled"
    add_config CONFIG_HYPERVISOR_GUEST n
    add_config CONFIG_KVM_GUEST n
    add_config CONFIG_HYPERV n
    add_config CONFIG_VBOXGUEST n
    add_config CONFIG_PARAVIRT n
    add_config CONFIG_XEN n
    add_config CONFIG_VIRTIO n
    add_config CONFIG_VIRTIO_PCI_LIB n
    add_config CONFIG_VIRTIO_PCI_LIB_LEGACY n
    add_config CONFIG_VIRTIO_MENU n
    add_config CONFIG_VIRTIO_PCI n
fi