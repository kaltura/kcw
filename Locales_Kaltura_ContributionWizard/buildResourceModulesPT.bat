@echo off

cd "C:\Documents and Settings\user\My Documents\Flex Builder 3\Locales_Kaltura_ContributionWizard"

mxmlc -locale=pt_PT -source-path=locale/{locale} -include-resource-bundles=CairngormMessages,Errors,FinishScreen,ImportBrowser,ImportModuleLoader,IntroScreen,MediaTypes,PendingMessages,SearchAuthenticationScreen,SearchImportView,Tagging,TermsOfUseScreen,UploadImportView,WebcamView,SoundRecorderView,collections,containers,controls,core,effects,logging,messaging,rpc,skins,states,styles,SharedResources,PendingMessages,PermissionLevels,MediaProviders -output=pt_PT_ContributionWizard_kaltura.swf