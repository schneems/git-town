package cmd

import (
	"github.com/Originate/git-town/src/cfmt"
	"github.com/Originate/git-town/src/git"
	"github.com/Originate/git-town/src/util"
	"github.com/spf13/cobra"
)

var newBranchPushFlagCommand = &cobra.Command{
	Use:   "new-branch-push-flag [(true | false)]",
	Short: "Displays or sets your new branch push flag",
	Long: `Displays or sets your new branch push flag

Branches created with hack / append / prepend will be pushed upon creation
if and only if "new-branch-push-flag" is true. The default value is false.`,
	Run: func(cmd *cobra.Command, args []string) {
		if len(args) == 0 {
			printNewBranchPushFlag()
		} else {
			setNewBranchPushFlag(util.StringToBool(args[0]))
		}
	},
	PreRunE: func(cmd *cobra.Command, args []string) error {
		if len(args) == 1 {
			err := validateBooleanArgument(args[0])
			if err != nil {
				return err
			}
		}
		return util.FirstError(
			validateMaxArgsFunc(args, 1),
			git.ValidateIsRepository,
		)
	},
}

func printNewBranchPushFlag() {
	if globalFlag {
		cfmt.Println(git.GetGlobalNewBranchPushFlag())
	} else {
		cfmt.Println(git.GetPrintableNewBranchPushFlag())
	}
}

func setNewBranchPushFlag(value bool) {
	if globalFlag {
		git.UpdateGlobalShouldNewBranchPush(value)
	} else {
		git.UpdateShouldNewBranchPush(value)
	}
}

func init() {
	newBranchPushFlagCommand.Flags().BoolVar(&globalFlag, "global", false, "Displays or sets you global new branch push flag")
	RootCmd.AddCommand(newBranchPushFlagCommand)
}
