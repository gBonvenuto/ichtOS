	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"kernel.c"
	.file	0 "/home/gian/Projetos/ichtOS" "kernel.c" md5 0xed4e74386a81b8502d3fbf3a8c0ea7ee
	.text
	.globl	memset                          # -- Begin function memset
	.p2align	1
	.type	memset,@function
memset:                                 # @memset
.Lfunc_begin0:
	.cfi_sections .debug_frame
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: memset:buf <- $x10
	#DEBUG_VALUE: memset:c <- $x11
	#DEBUG_VALUE: memset:p <- $x10
	#DEBUG_VALUE: memset:n <- [DW_OP_constu 1, DW_OP_minus, DW_OP_stack_value] $x12
	.loc	0 13 3 prologue_end             # kernel.c:13:3
	beqz	a2, .LBB0_3
.Ltmp0:
# %bb.1:
	#DEBUG_VALUE: memset:n <- [DW_OP_constu 1, DW_OP_minus, DW_OP_stack_value] $x12
	#DEBUG_VALUE: memset:p <- $x10
	#DEBUG_VALUE: memset:c <- $x11
	#DEBUG_VALUE: memset:buf <- $x10
	#DEBUG_VALUE: memset:c <- $x11
	add	a2, a2, a0
.Ltmp1:
	.loc	0 0 3 is_stmt 0                 # kernel.c:0:3
	mv	a3, a0
.Ltmp2:
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: memset:c <- $x11
	#DEBUG_VALUE: memset:buf <- $x10
	#DEBUG_VALUE: memset:p <- $x13
	#DEBUG_VALUE: memset:n <- undef
	.loc	0 14 7 is_stmt 1                # kernel.c:14:7
	addi	a4, a3, 1
.Ltmp3:
	#DEBUG_VALUE: memset:p <- $x14
	.loc	0 14 10 is_stmt 0               # kernel.c:14:10
	sb	a1, 0(a3)
	mv	a3, a4
.Ltmp4:
	#DEBUG_VALUE: memset:p <- $x13
	.loc	0 13 3 is_stmt 1                # kernel.c:13:3
	bne	a4, a2, .LBB0_2
.Ltmp5:
.LBB0_3:
	#DEBUG_VALUE: memset:c <- $x11
	#DEBUG_VALUE: memset:buf <- $x10
	.loc	0 16 3                          # kernel.c:16:3
	ret
.Ltmp6:
.Lfunc_end0:
	.size	memset, .Lfunc_end0-memset
	.cfi_endproc
                                        # -- End function
	.globl	kernel_main                     # -- Begin function kernel_main
	.p2align	1
	.type	kernel_main,@function
kernel_main:                            # @kernel_main
.Lfunc_begin1:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: memset:c <- 0
	.loc	0 13 3 prologue_end             # kernel.c:13:3
	lui	a1, %hi(__bss)
	addi	a1, a1, %lo(__bss)
.Ltmp7:
	#DEBUG_VALUE: memset:buf <- $x11
	#DEBUG_VALUE: memset:p <- $x11
	lui	a0, %hi(__bss_end)
	addi	a0, a0, %lo(__bss_end)
	sub	a2, a0, a1
.Ltmp8:
	#DEBUG_VALUE: memset:n <- [DW_OP_constu 1, DW_OP_minus, DW_OP_stack_value] $x12
	beqz	a2, .LBB1_2
.Ltmp9:
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: memset:p <- $x11
	#DEBUG_VALUE: memset:c <- 0
	#DEBUG_VALUE: memset:p <- $x11
	#DEBUG_VALUE: memset:n <- undef
	.loc	0 14 7                          # kernel.c:14:7
	addi	a2, a1, 1
.Ltmp10:
	#DEBUG_VALUE: memset:p <- $x12
	.loc	0 14 10 is_stmt 0               # kernel.c:14:10
	sb	zero, 0(a1)
	mv	a1, a2
.Ltmp11:
	#DEBUG_VALUE: memset:p <- $x11
	.loc	0 13 3 is_stmt 1                # kernel.c:13:3
	bne	a2, a0, .LBB1_1
.Ltmp12:
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	.loc	0 23 3                          # kernel.c:23:3
	j	.LBB1_2
.Ltmp13:
.Lfunc_end1:
	.size	kernel_main, .Lfunc_end1-kernel_main
	.cfi_endproc
                                        # -- End function
	.section	.text.boot,"ax",@progbits
	.globl	boot                            # -- Begin function boot
	.p2align	1
	.type	boot,@function
boot:                                   # @boot
.Lfunc_begin2:
	.cfi_startproc
# %bb.0:
	.loc	0 31 3 prologue_end             # kernel.c:31:3
	lui	a0, %hi(__stack_top)
	addi	a0, a0, %lo(__stack_top)
	#APP
	mv	sp, a0
	j	kernel_main

	#NO_APP
.Ltmp14:
.Lfunc_end2:
	.size	boot, .Lfunc_end2-boot
	.cfi_endproc
                                        # -- End function
	.section	.debug_loclists,"",@progbits
	.word	.Ldebug_list_header_end0-.Ldebug_list_header_start0 # Length
.Ldebug_list_header_start0:
	.half	5                               # Version
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
	.word	5                               # Offset entry count
.Lloclists_table_base0:
	.word	.Ldebug_loc0-.Lloclists_table_base0
	.word	.Ldebug_loc1-.Lloclists_table_base0
	.word	.Ldebug_loc2-.Lloclists_table_base0
	.word	.Ldebug_loc3-.Lloclists_table_base0
	.word	.Ldebug_loc4-.Lloclists_table_base0
.Ldebug_loc0:
	.byte	1                               # DW_LLE_base_addressx
	.byte	0                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Lfunc_begin0-.Lfunc_begin0    #   starting offset
	.uleb128 .Ltmp2-.Lfunc_begin0           #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp2-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp3-.Lfunc_begin0           #   ending offset
	.byte	1                               # Loc expr size
	.byte	93                              # DW_OP_reg13
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp3-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp4-.Lfunc_begin0           #   ending offset
	.byte	1                               # Loc expr size
	.byte	94                              # DW_OP_reg14
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp4-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp5-.Lfunc_begin0           #   ending offset
	.byte	1                               # Loc expr size
	.byte	93                              # DW_OP_reg13
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc1:
	.byte	3                               # DW_LLE_startx_length
	.byte	0                               #   start index
	.uleb128 .Ltmp1-.Lfunc_begin0           #   length
	.byte	3                               # Loc expr size
	.byte	124                             # DW_OP_breg12
	.byte	127                             # -1
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc2:
	.byte	1                               # DW_LLE_base_addressx
	.byte	0                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp7-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp9-.Lfunc_begin0           #   ending offset
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc3:
	.byte	1                               # DW_LLE_base_addressx
	.byte	0                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp7-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp10-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp10-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp11-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	92                              # DW_OP_reg12
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp11-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp12-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc4:
	.byte	1                               # DW_LLE_base_addressx
	.byte	0                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp8-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp9-.Lfunc_begin0           #   ending offset
	.byte	3                               # Loc expr size
	.byte	124                             # DW_OP_breg12
	.byte	127                             # -1
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_list_header_end0:
	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	37                              # DW_FORM_strx1
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	114                             # DW_AT_str_offsets_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	37                              # DW_FORM_strx1
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	85                              # DW_AT_ranges
	.byte	35                              # DW_FORM_rnglistx
	.byte	115                             # DW_AT_addr_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	116                             # DW_AT_rnglists_base
	.byte	23                              # DW_FORM_sec_offset
	.ascii	"\214\001"                      # DW_AT_loclists_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	3                               # Abbreviation Code
	.byte	22                              # DW_TAG_typedef
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	32                              # DW_AT_inline
	.byte	33                              # DW_FORM_implicit_const
	.byte	1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
	.byte	29                              # DW_TAG_inlined_subroutine
	.byte	1                               # DW_CHILDREN_yes
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	88                              # DW_AT_call_file
	.byte	11                              # DW_FORM_data1
	.byte	89                              # DW_AT_call_line
	.byte	11                              # DW_FORM_data1
	.byte	87                              # DW_AT_call_column
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	15                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	28                              # DW_AT_const_value
	.byte	15                              # DW_FORM_udata
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	16                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	0                               # DW_CHILDREN_no
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.word	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.half	5                               # DWARF version number
	.byte	1                               # DWARF Unit Type
	.byte	4                               # Address Size (in bytes)
	.word	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	1                               # Abbrev [1] 0xc:0xd7 DW_TAG_compile_unit
	.byte	0                               # DW_AT_producer
	.half	29                              # DW_AT_language
	.byte	1                               # DW_AT_name
	.word	.Lstr_offsets_base0             # DW_AT_str_offsets_base
	.word	.Lline_table_start0             # DW_AT_stmt_list
	.byte	2                               # DW_AT_comp_dir
	.word	0                               # DW_AT_low_pc
	.byte	0                               # DW_AT_ranges
	.word	.Laddr_table_base0              # DW_AT_addr_base
	.word	.Lrnglists_table_base0          # DW_AT_rnglists_base
	.word	.Lloclists_table_base0          # DW_AT_loclists_base
	.byte	2                               # Abbrev [2] 0x2b:0x5 DW_TAG_pointer_type
	.word	48                              # DW_AT_type
	.byte	3                               # Abbrev [3] 0x30:0x8 DW_TAG_typedef
	.word	56                              # DW_AT_type
	.byte	4                               # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	1                               # DW_AT_decl_line
	.byte	4                               # Abbrev [4] 0x38:0x4 DW_TAG_base_type
	.byte	3                               # DW_AT_name
	.byte	8                               # DW_AT_encoding
	.byte	1                               # DW_AT_byte_size
	.byte	3                               # Abbrev [3] 0x3c:0x8 DW_TAG_typedef
	.word	68                              # DW_AT_type
	.byte	7                               # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	3                               # DW_AT_decl_line
	.byte	3                               # Abbrev [3] 0x44:0x8 DW_TAG_typedef
	.word	76                              # DW_AT_type
	.byte	6                               # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	2                               # DW_AT_decl_line
	.byte	4                               # Abbrev [4] 0x4c:0x4 DW_TAG_base_type
	.byte	5                               # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	5                               # Abbrev [5] 0x50:0x27 DW_TAG_subprogram
	.byte	0                               # DW_AT_low_pc
	.word	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.word	119                             # DW_AT_abstract_origin
	.byte	6                               # Abbrev [6] 0x5c:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	90
	.word	127                             # DW_AT_abstract_origin
	.byte	6                               # Abbrev [6] 0x63:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	91
	.word	135                             # DW_AT_abstract_origin
	.byte	7                               # Abbrev [7] 0x6a:0x6 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.word	143                             # DW_AT_abstract_origin
	.byte	8                               # Abbrev [8] 0x70:0x6 DW_TAG_variable
	.byte	0                               # DW_AT_location
	.word	151                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	9                               # Abbrev [9] 0x77:0x29 DW_TAG_subprogram
	.byte	8                               # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	160                             # DW_AT_type
                                        # DW_AT_external
                                        # DW_AT_inline
	.byte	10                              # Abbrev [10] 0x7f:0x8 DW_TAG_formal_parameter
	.byte	9                               # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.word	160                             # DW_AT_type
	.byte	10                              # Abbrev [10] 0x87:0x8 DW_TAG_formal_parameter
	.byte	10                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.word	161                             # DW_AT_type
	.byte	10                              # Abbrev [10] 0x8f:0x8 DW_TAG_formal_parameter
	.byte	12                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	11                              # DW_AT_decl_line
	.word	60                              # DW_AT_type
	.byte	11                              # Abbrev [11] 0x97:0x8 DW_TAG_variable
	.byte	13                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	12                              # DW_AT_decl_line
	.word	43                              # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	12                              # Abbrev [12] 0xa0:0x1 DW_TAG_pointer_type
	.byte	4                               # Abbrev [4] 0xa1:0x4 DW_TAG_base_type
	.byte	11                              # DW_AT_name
	.byte	8                               # DW_AT_encoding
	.byte	1                               # DW_AT_byte_size
	.byte	13                              # Abbrev [13] 0xa5:0x32 DW_TAG_subprogram
	.byte	1                               # DW_AT_low_pc
	.word	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	14                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	19                              # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	14                              # Abbrev [14] 0xb0:0x26 DW_TAG_inlined_subroutine
	.word	119                             # DW_AT_abstract_origin
	.byte	1                               # DW_AT_low_pc
	.word	.Ltmp12-.Lfunc_begin1           # DW_AT_high_pc
	.byte	0                               # DW_AT_call_file
	.byte	22                              # DW_AT_call_line
	.byte	3                               # DW_AT_call_column
	.byte	7                               # Abbrev [7] 0xbd:0x6 DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.word	127                             # DW_AT_abstract_origin
	.byte	15                              # Abbrev [15] 0xc3:0x6 DW_TAG_formal_parameter
	.byte	0                               # DW_AT_const_value
	.word	135                             # DW_AT_abstract_origin
	.byte	7                               # Abbrev [7] 0xc9:0x6 DW_TAG_formal_parameter
	.byte	4                               # DW_AT_location
	.word	143                             # DW_AT_abstract_origin
	.byte	8                               # Abbrev [8] 0xcf:0x6 DW_TAG_variable
	.byte	3                               # DW_AT_location
	.word	151                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	16                              # Abbrev [16] 0xd7:0xb DW_TAG_subprogram
	.byte	2                               # DW_AT_low_pc
	.word	.Lfunc_end2-.Lfunc_begin2       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	15                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	30                              # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_rnglists,"",@progbits
	.word	.Ldebug_list_header_end1-.Ldebug_list_header_start1 # Length
.Ldebug_list_header_start1:
	.half	5                               # Version
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
	.word	1                               # Offset entry count
.Lrnglists_table_base0:
	.word	.Ldebug_ranges0-.Lrnglists_table_base0
.Ldebug_ranges0:
	.byte	3                               # DW_RLE_startx_length
	.byte	0                               #   start index
	.uleb128 .Lfunc_end1-.Lfunc_begin0      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	2                               #   start index
	.uleb128 .Lfunc_end2-.Lfunc_begin2      #   length
	.byte	0                               # DW_RLE_end_of_list
.Ldebug_list_header_end1:
	.section	.debug_str_offsets,"",@progbits
	.word	68                              # Length of String Offsets Set
	.half	5
	.half	0
.Lstr_offsets_base0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 20.1.7 (Fedora 20.1.7-1.fc42)" # string offset=0
.Linfo_string1:
	.asciz	"kernel.c"                      # string offset=44
.Linfo_string2:
	.asciz	"/home/gian/Projetos/ichtOS"    # string offset=53
.Linfo_string3:
	.asciz	"unsigned char"                 # string offset=80
.Linfo_string4:
	.asciz	"uint8_t"                       # string offset=94
.Linfo_string5:
	.asciz	"unsigned int"                  # string offset=102
.Linfo_string6:
	.asciz	"uint32_t"                      # string offset=115
.Linfo_string7:
	.asciz	"size_t"                        # string offset=124
.Linfo_string8:
	.asciz	"memset"                        # string offset=131
.Linfo_string9:
	.asciz	"buf"                           # string offset=138
.Linfo_string10:
	.asciz	"c"                             # string offset=142
.Linfo_string11:
	.asciz	"char"                          # string offset=144
.Linfo_string12:
	.asciz	"n"                             # string offset=149
.Linfo_string13:
	.asciz	"p"                             # string offset=151
.Linfo_string14:
	.asciz	"kernel_main"                   # string offset=153
.Linfo_string15:
	.asciz	"boot"                          # string offset=165
	.section	.debug_str_offsets,"",@progbits
	.word	.Linfo_string0
	.word	.Linfo_string1
	.word	.Linfo_string2
	.word	.Linfo_string3
	.word	.Linfo_string4
	.word	.Linfo_string5
	.word	.Linfo_string6
	.word	.Linfo_string7
	.word	.Linfo_string8
	.word	.Linfo_string9
	.word	.Linfo_string10
	.word	.Linfo_string11
	.word	.Linfo_string12
	.word	.Linfo_string13
	.word	.Linfo_string14
	.word	.Linfo_string15
	.section	.debug_addr,"",@progbits
	.word	.Ldebug_addr_end0-.Ldebug_addr_start0 # Length of contribution
.Ldebug_addr_start0:
	.half	5                               # DWARF version number
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
.Laddr_table_base0:
	.word	.Lfunc_begin0
	.word	.Lfunc_begin1
	.word	.Lfunc_begin2
.Ldebug_addr_end0:
	.ident	"clang version 20.1.7 (Fedora 20.1.7-1.fc42)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __bss
	.addrsig_sym __bss_end
	.addrsig_sym __stack_top
	.section	.debug_line,"",@progbits
.Lline_table_start0:
