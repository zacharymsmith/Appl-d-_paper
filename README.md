Repository for files and scripts associated with APPLd manuscript. All possible files archived here. Files too large for GitHub deposition are stored at https://doi.org/10.5281/zenodo.17751181 
├── Folder 1
│   ├── SampleQC_precleanup.pdf # Sample QC summary of all findings on the initial submitted sample before AMPure cleanup
│   ├── SampleQC_data_precleanup.pdf    # Sample QC data supporting data summary
│   ├── AZENTA_NGS_PacBio_Data_Report.pdf                # Sequencing run report data 
│   └── APPLdM.hifireads.fastq.gz                # HiFi raw reads from APPLd PacBio Revio
│
├── Folder 2
│   ├── APPLd_assembly.merfin_racon2.fa  # Final Merfin-polished genome assembly
│   ├── appld_reads.histo.txt  # Jellyfish histogram input for GenomeScope
│   ├── quast_output/ directory  # Full QUAST stats and misassembly info
│   ├── appld_busco/ directory   # Raw BUSCO analysis output files
│   ├── coverage_bins.txt  # Raw per-bin depth data for heatmap
│   ├── coverage.tsv   # Samtools per-region coverage summary
│   ├── primary_assembly_QUAST.pdf  # Quality assesment pre polishing
│   └── polished_assembly_QUAST.pdf                 # Quality assesment post polishing
│
├── Folder 3
│   ├── appl_vs_appld.blast  # BLAST alignment of Appl CDS against the APPLd genome (for panel D)
│   ├── dm6_r6.62.fa  # Reference genome used for mapping, variant calling, and visualizations
│   ├── dmel-all-r6.62.gtf.gz  # Reference genome annotation file used for gene track visualization
│   ├── appld_freebayes.pacbio.vcf.gz   # Variant calls (FreeBayes) mapped to the reference for VCF visualization
│   ├── appld_longshot.vcf.gz  # Variant calls (Longshot) for comparison, including panel A Venn counts
│   ├── mapped_dm6.sorted.bam  # Reads from APPLd flies mapped to dm6 for coverage and deletion analysis
│   └── mapped_dm6.sorted.bam.bai                 # BAM index required for IGV/jBrowse viewing
│
├── Folder 4
│   ├── pseudoX_singleline.fa  # Fasta of PseudoX reconstruction from ptg000067l + 20nt + ptg000024l RC
│   ├── final_genesblast_bed.bed  # BED file of filtered BLAST hits for elav, Appl, and vnd to PseudoX
│   ├── high_coverage_only.gtf  # Liftoff annotation (coverage ≥0.95) for genes mapped to PseudoX
│   ├── combined_dgenies_alignments/   # PDF/PNG alignments of PseudoX and full genome to dm6 chrX (from D-GENIES)
│   ├── blastn_appl_vs_pseudoX.tsv  # Raw BLAST output of Appl CDS to PseudoX
│   ├── contig_orient_mapping/ directory  # Folder containing all eight pseudo-X orientation assemblies
│   └── appl_vs_appld_on_appl.bed                # File of contig hits mapped on the Appl locus for visualization on Flybase Appl CDS
│
├── Folder 5
│   ├── T2A_stainfree_gel.jpg  # Image of stainfree gel for T2A blot normalization 
│   ├── T2A_AP2_blot.jpg  # Image of membrane for T2A blot using chicken anti-APPL (Philip Copenhaver)
│   └── Appl-GFP_blot_quant.png                # Image of Appl-GFP blot and quantification in figure format 
│
├── Folder 6
│   ├── timsTOF_data_allgroups.xlsx  # timsTOF data from all comparisons
│   ├── APPLdvW1118cytoscape.cys  # APPLd vs W1118 cytoscape PPI from Metascape
│   ├── APPLdvW1118_cytoscape_clusters.xlsx  # APPLd vs W1118 pathways from Metascape
│   ├── AppldVsW1118_volcano   # Prism file containing information from APPLd to W1118 comparison of timsTOF
│   ├── T2AvCantoncytoscape.cys  # Appl-T2A-GAL4 v CantonS cytoscape PPI from Metascape
│   ├── T2AvCantonS_cytoscape_clusters.xlsx  # Appl-T2A-GAL4 v CantonS pathways from Metascape
│   ├── T2AVsCanton_volcano   # Prism file containing information from Appl-T2A-GAL4 to CantonS comparison of timsTOF
│   ├── APPLdvT2Acytoscape.cys  # APPLd v Appl-T2A-GAL4 cytoscape PPI from Metascape
│   ├── APPLdvT2A_cytoscape_clusters.xlsx  # APPLd v Appl-T2A-GAL4 pathways from Metascape
│   └── AppldVsT2A_volcano               # Prism file containing information from APPLd to Appl-T2A-GAL4 comparison of timsTOF
│
├── Folder 7
│   ├── Appl_signature_table.xlsx  # List of proteins found to be significant in T2A/CantonS and APPLd/W1118 but not in APPLd/T2A
│   ├── APPLd_signature_table.xlsx  # List of proteins found to be significant in APPLd/T2A and APPLd/W1118 but not in CantonS/W1118
│   ├── CG3156 CDS.prot  # Normal predicted protein sequence of CG3156
│   ├── CG3156 altered CDS.prot   # Altered predicted protein sequence of CG3156 in APPLd
│   ├── Pdzd8 CDS.prot  # Normal predicted protein sequence of Pdzd8
│   └── Pdzd8 altered CDS.prot               # Altered predicted protein sequence of Pdzd8 in APPLd
│
├── Folder 8
│   ├── orbitrap APPLd Volcano Prism Data.xlsx  # Processed protein-level differential expression results (Figure 4B)
│   ├── orbitrap GO_MCODE.csv  # Enrichment summary for MCODE clusters generated in Metascape (Figure 4A)
│   ├── orbitrap metascape_scaling_values.xlsx  # Node metadata for Cytoscape PPI map
│   ├── orbitrap metascapefinalAPPLd_BACKGROUND.xlsx  # List of all background proteins detected and used in the Metascape analysis for enrichment
│   └── orbitrap metascapefinalAPPLd_SIG.xlsx               # Filtered list of significantly differentially expressed proteins for Metascape input
│
├── Folder 9
│   └── MetaComparisonProteomics.xlsx               # Raw and processed comparison between the current study and gene list from Nithianandam et al., 2023
│
├── Folder 10
│   └── APPLd_signature_primers.xlsx              # Primers uses for verification of APPLd predicted mutations from proteomic signature and genome assembly for use in sanger sequencing
│
├── Folder 11
│   ├── SleepAnticipationScript.R  # Custom R pipeline for calculating Morning (MAI) and Evening (EAI) Anticipation Indices
│   ├── ClimbingLmmScript.R  # R script for Linear Mixed-Model (LMM) analysis of negative geotaxis velocity
│   ├── Figure7D_RawClimbingData.csv  # Raw climbing data as presented in Figure 7D
│   └── Figure7A_IndividualSleepProfiles.csv              # Individual sleep profiles as presented in Figure 7A
