                         ====================
                         pb_v1_readme_1st.txt
                         ====================



Files that you will download allow you to upgrade your current
installation of UG/Post Builder to the official version 1.0 release.



---------
Attention
---------
* The files to be downloaded here will ONLY UPGRADE the existing 
  installation of the UG/Post Builder.  You MUST have the POSTBUILD
  kit from UG v16.0.1.3 or newer installed first.

* You will need additional 15 M disk space to install this upgrade.

* This upgrade can be applied onto the versions of Post Builder
  installed in UG v16.0.1.3 or newer.

* Existing files in your current installation of Post Builder will
  be overwritten.  You may want to backup your current installation
  before installing this upgrade for possible restoration.



------------
Installation
------------
You will follow the procedure described below to install
this new release:


1. Download appropriate version of "pb_v1_xxx.tar.gz" archive for
   your Operating/System as follows:

        pb_v1_aix.tar.gz  (for IBM/AIX)
        pb_v1_hpp.tar.gz  (for HP)
        pb_v1_osf.tar.gz  (for DEC/OSF)
        pb_v1_sgi.tar.gz  (for SGI)
        pb_v1_sol.tar.gz  (for SUN/SOL)
        pb_v1_wnti.tar.gz (for Windows NT/Intel)

2. Copy or move them to the parent directory of the "postbuild"
   directory.  Normally, this will be the "UGII_BASE_DIR" directory.

3.
 << Unix >>
   Use "gunzip < pb_v1_xxx.tar.gz | tar xvf -" command to decompress the
   archive.  This will overwrite the existing files with the updated
   ones accordingly.


 << Windows NT >>
   Use "WinZip" to decompress "pb_v1_wnti.tar.gz" with following steps:
   - Answer "I Agree" to gain permission to use WinZip.
   - Answer "Yes" to the next message dialog. This will allow WinZip
     to decompress the archive to a temporary folder and open it.
   - Select "Extract" button on the WinZip dialog. This will bring up
     the "Extract" options dialog.
   - On this dialog, set the "Extract to" path to the parent directory
     of the "postbuild" directory, and set other options on the
     dialog to "All Files", "Overwrite existing files" and
     "Use folder names", then press "Extract" button to start
     decompressing the archive.


 
-----------------------
ui_pb_user_resource.tcl
-----------------------
After the installation, you'll find the file "ui_pb_user_resource.tcl"
in the "postbuild/app/ui" directory. This file allows you to
customize various elements of the Post Builder appearance such as the
font set/size and the command that displays your Netscape browser on
Unix.  Each user can have his/her own customization by placing this
file into his/her home directory. You may refer to the
"ui_pb_resource.tcl" in the "postbuild/app/ui" directory to find all
the elements that can be customized in Post Builder.



---------------
ugpost_base.tcl
---------------
In the "postbuild/pblib" directory you will also find the latest
version of the "ugpost_base.tcl".  You will have to copy this file to
the "mach/resource/postprocessor" directory in order to gain the
latest functionalities of the UG/Post.



--------
Appendix
--------
.
|-- postbuild
|       |-- pb_v1_readme_1st.txt
|       |-- app
|       |      |-- Postino
|       |      |-- dbase
|       |      |      |-- pb_address_tcl.txt
|       |      |      |-- pb_block_tcl.txt
|       |      |      |-- pb_class_tcl.txt
|       |      |      |-- pb_common_tcl.txt
|       |      |      |-- pb_event_tcl.txt
|       |      |      |-- pb_file_tcl.txt
|       |      |      |-- pb_mdfa_tcl.txt
|       |      |      |-- pb_format_tcl.txt
|       |      |      |-- pb_list_tcl.txt
|       |      |      |-- pb_machine_tcl.txt
|       |      |      |-- pb_method_tcl.txt
|       |      |      |-- pb_output_tcl.txt
|       |      |      |-- pb_proc_parser_tcl.txt
|       |      |      |-- pb_pui_parser_tcl.txt
|       |      |      |-- pb_sequence_tcl.txt
|       |      |      |-- pb_ude_tcl.txt
|       |      |      |-- pb_var_parser_tcl.txt
|       |      |-- ui
|       |      |      |-- ui_pb_resource.tcl
|       |      |      |-- ui_pb_debug.tcl
|       |      |      |-- ui_pb_main_tcl.txt
|       |      |      |-- ui_pb_context_help_tcl.txt
|       |      |      |-- ui_pb_user_resource.tcl
|       |      |      |-- ui_pb_address_tcl.txt
|       |      |      |-- ui_pb_addrseq_tcl.txt
|       |      |      |-- ui_pb_addrsum_tcl.txt
|       |      |      |-- ui_pb_advisor_tcl.txt
|       |      |      |-- ui_pb_balloon_tcl.txt
|       |      |      |-- ui_pb_block_tcl.txt
|       |      |      |-- ui_pb_class_tcl.txt
|       |      |      |-- ui_pb_cmdmsg_tcl.txt
|       |      |      |-- ui_pb_common_tcl.txt
|       |      |      |-- ui_pb_definition_tcl.txt
|       |      |      |-- ui_pb_file_tcl.txt
|       |      |      |-- ui_pb_format_tcl.txt
|       |      |      |-- ui_pb_gcode_tcl.txt
|       |      |      |-- ui_pb_list_tcl.txt
|       |      |      |-- ui_pb_machine_tcl.txt
|       |      |      |-- ui_pb_mcode_tcl.txt
|       |      |      |-- ui_pb_method_tcl.txt
|       |      |      |-- ui_pb_others_tcl.txt
|       |      |      |-- ui_pb_preview_tcl.txt
|       |      |      |-- ui_pb_program_tcl.txt
|       |      |      |-- ui_pb_progtpth_tcl.txt
|       |      |      |-- ui_pb_sequence_tcl.txt
|       |      |      |-- ui_pb_toolpath_tcl.txt
|       |-- images
|       |      |-- pb_hg500.gif
|       |      |-- mach_tool
|       |      |      |-- pb_l2x.gif
|       |      |      |-- pb_l4x.gif
|       |-- pblib
|       |      |-- pb_Lathe_2_Generic_IN.def
|       |      |-- pb_Lathe_2_Generic_IN.pui
|       |      |-- pb_Lathe_2_Generic_IN.tcl
|       |      |-- pb_Lathe_2_Generic_MM.def
|       |      |-- pb_Lathe_2_Generic_MM.pui
|       |      |-- pb_Lathe_2_Generic_MM.tcl
|       |      |-- pb_Mill_3_Generic_IN.def
|       |      |-- pb_Mill_3_Generic_IN.pui
|       |      |-- pb_Mill_3_Generic_IN.tcl
|       |      |-- pb_Mill_3_Generic_MM.def
|       |      |-- pb_Mill_3_Generic_MM.pui
|       |      |-- pb_Mill_3_Generic_MM.tcl
|       |      |-- pb_Mill_4H_Generic_IN.def
|       |      |-- pb_Mill_4H_Generic_IN.pui
|       |      |-- pb_Mill_4H_Generic_IN.tcl
|       |      |-- pb_Mill_4H_Generic_MM.def
|       |      |-- pb_Mill_4H_Generic_MM.pui
|       |      |-- pb_Mill_4H_Generic_MM.tcl
|       |      |-- pb_Mill_4T_Generic_IN.def
|       |      |-- pb_Mill_4T_Generic_IN.pui
|       |      |-- pb_Mill_4T_Generic_IN.tcl
|       |      |-- pb_Mill_4T_Generic_MM.def
|       |      |-- pb_Mill_4T_Generic_MM.pui
|       |      |-- pb_Mill_4T_Generic_MM.tcl
|       |      |-- pb_Mill_5HH_Generic_IN.def
|       |      |-- pb_Mill_5HH_Generic_IN.pui
|       |      |-- pb_Mill_5HH_Generic_IN.tcl
|       |      |-- pb_Mill_5HH_Generic_MM.def
|       |      |-- pb_Mill_5HH_Generic_MM.pui
|       |      |-- pb_Mill_5HH_Generic_MM.tcl
|       |      |-- pb_Mill_5HT_Generic_IN.def
|       |      |-- pb_Mill_5HT_Generic_IN.pui
|       |      |-- pb_Mill_5HT_Generic_IN.tcl
|       |      |-- pb_Mill_5HT_Generic_MM.def
|       |      |-- pb_Mill_5HT_Generic_MM.pui
|       |      |-- pb_Mill_5HT_Generic_MM.tcl
|       |      |-- pb_Mill_5TT_Generic_IN.def
|       |      |-- pb_Mill_5TT_Generic_IN.pui
|       |      |-- pb_Mill_5TT_Generic_IN.tcl
|       |      |-- pb_Mill_5TT_Generic_MM.def
|       |      |-- pb_Mill_5TT_Generic_MM.tcl
|       |      |-- pb_Mill_5TT_Generic_MM.pui
|       |      |-- ude.def
|       |      |-- ugpost_base.tcl
|       |      |-- wedm.def
|       |      |-- wedm.tcl
|       |-- tcl
|       |      |-- share
|       |      |      |-- tix4.1
|       |      |      |      |-- StdBBox.tcl
|       |-- doc
|       |      |-- appendixa.html
|       |      |-- canned_cycles.html
|       |      |-- customization.html
|       |      |-- custom_command.html
|       |      |-- data_definitions.html
|       |      |-- end_sequences.html
|       |      |-- files_preview.html
|       |      |-- glossary.html
|       |      |-- g_code_summary.html
|       |      |-- help.html
|       |      |-- image00e.jpg
|       |      |-- image040.jpg
|       |      |-- image1nn.jpg
|       |      |-- image1q0.jpg
|       |      |-- image22k.jpg
|       |      |-- image23m.jpg
|       |      |-- image2le.jpg
|       |      |-- image2om.jpg
|       |      |-- image2r4.jpg
|       |      |-- image3u0.jpg
|       |      |-- image431.jpg
|       |      |-- image44d.jpg
|       |      |-- image4mu.jpg
|       |      |-- image4n7.jpg
|       |      |-- image4p5.jpg
|       |      |-- image52g.jpg
|       |      |-- image5tk.jpg
|       |      |-- image61t.jpg
|       |      |-- image63b.jpg
|       |      |-- image690.jpg
|       |      |-- image6bb.jpg
|       |      |-- image6e4.jpg
|       |      |-- image6jo.jpg
|       |      |-- image6lh.jpg
|       |      |-- image6oa.jpg
|       |      |-- image6t3.jpg
|       |      |-- image6vp.jpg
|       |      |-- image76u.jpg
|       |      |-- image799.jpg
|       |      |-- image7nh.jpg
|       |      |-- image872.jpg
|       |      |-- image8il.jpg
|       |      |-- image8s4.jpg
|       |      |-- image8se.jpg
|       |      |-- imageai6.jpg
|       |      |-- imageatc.jpg
|       |      |-- imageb4s.jpg
|       |      |-- imagebhk.jpg
|       |      |-- imagebiv.jpg
|       |      |-- imagebt5.jpg
|       |      |-- imagec0h.jpg
|       |      |-- imagecfc.jpg
|       |      |-- imagechj.jpg
|       |      |-- imagecjm.jpg
|       |      |-- imaged4o.jpg
|       |      |-- imagedbt.jpg
|       |      |-- imagedin.jpg
|       |      |-- imagedlp.jpg
|       |      |-- imagedou.jpg
|       |      |-- imageen5.jpg
|       |      |-- imageeno.jpg
|       |      |-- imageer6.jpg
|       |      |-- imagefa5.jpg
|       |      |-- imagefks.jpg
|       |      |-- imageg4g.jpg
|       |      |-- imageg63.jpg
|       |      |-- imageg9i.jpg
|       |      |-- imagegq7.jpg
|       |      |-- imagegru.jpg
|       |      |-- imageh2o.jpg
|       |      |-- imagehkf.jpg
|       |      |-- imagei4a.jpg
|       |      |-- imagei4h.jpg
|       |      |-- imageib4.jpg
|       |      |-- imageidl.jpg
|       |      |-- imageigm.jpg
|       |      |-- imageiij.jpg
|       |      |-- imagej4k.jpg
|       |      |-- imagek8s.jpg
|       |      |-- imageknp.jpg
|       |      |-- imagekqd.jpg
|       |      |-- imagekse.jpg
|       |      |-- imagel3k.jpg
|       |      |-- imagelll.jpg
|       |      |-- imagelul.jpg
|       |      |-- imagemb7.jpg
|       |      |-- imagemc3.jpg
|       |      |-- imagemes.jpg
|       |      |-- imagemip.jpg
|       |      |-- imagen2t.jpg
|       |      |-- imagenpq.jpg
|       |      |-- imageotv.jpg
|       |      |-- imageov4.jpg
|       |      |-- imagep0c.jpg
|       |      |-- imagepoj.jpg
|       |      |-- imagepqo.jpg
|       |      |-- imagepsi.jpg
|       |      |-- imageqhu.jpg
|       |      |-- imageqo3.jpg
|       |      |-- imager0n.jpg
|       |      |-- imager87.jpg
|       |      |-- imagerdg.jpg
|       |      |-- imagert7.jpg
|       |      |-- images14.jpg
|       |      |-- imagesdo.jpg
|       |      |-- imaget2t.jpg
|       |      |-- imaget9v.jpg
|       |      |-- imagete3.jpg
|       |      |-- imagetld.jpg
|       |      |-- imagetm9.jpg
|       |      |-- imagetmg.jpg
|       |      |-- imagetp9.jpg
|       |      |-- imagetpd.jpg
|       |      |-- imageumh.jpg
|       |      |-- imageup8.jpg
|       |      |-- imageurs.jpg
|       |      |-- imagevc0.jpg
|       |      |-- introduction.html
|       |      |-- listing_file.html
|       |      |-- machine_control.html
|       |      |-- machine_tool.html
|       |      |-- motion.html
|       |      |-- m_code_summary.html
|       |      |-- pb.html
|       |      |-- pb_help.html
|       |      |-- pb_title.html
|       |      |-- program.html
|       |      |-- start_sequences.html
|       |      |-- word_sequence.html
|       |      |-- word_summary.html
