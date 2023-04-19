# Setting up the MSFR Stata labs

Now that you have downloaded the MSFR lab repository, you can begin work on the lab tasks. To start, navigate to the location you have downloaded the `manage-successful-field-research` folder and open it in your file browser. You can open the entire directory at once with an IDE like [Pulsar](https://pulsar-edit.dev) ([instructions](https://osf.io/tkcnh)). You can also view these `README` files and the instructions on the web [here](https://github.com/dime-worldbank/manage-successful-field-research/tree/main/2023/Stata), and open the do-files as needed in Stata directly.

The file download is organized so that you do not need to make any changes to the folder structure in order to complete the assignments. You may need to download or create datasets or other types of files; each lab will provide instructions on how and where to do that.

For now, open the `main.do` do-file in this folder. You will see that it has a very simple structure. It installs the Stata packages necessary to complete these lab exercises, prepares some general settings, and then is ready to run each of the do-files that you will use to complete the tasks for each lab. It assumes you have Stata version at least 16.1; if you do not, you can change that in the `ieboilstart` command. When you are ready to have the `main.do` file run a given file, change the corresponding logic flag to `(1)` so that it will run.

To ensure Stata will be able to find the files used in these labs, change the line beginning with `global msfr ....` so that the file path in quotation marks points to the `/Stata/` folder here. If the concept of file paths is not already familiar to you, take a moment to understand how file paths on your computer work and can be located. This varies by operating system; if you need specific instructions, ask for help, search for instructions, or query an AI assistant.

Throughout these lab sessions, there are several documents and resources you should refer to for help:

- Development Research in Practice: The DIME Analytics Data Handbook ([ebook](https://worldbank.github.io/dime-data-handbook/), [PDF](https://openknowledge.worldbank.org/entities/publication/c0d71cd5-064b-5c4f-a8d6-1be40bb3ee25), [Amazon](https://www.amazon.com/Development-Research-Practice-Analytics-Handbook/dp/1464816948))
- [The DIME Wiki](https://dimewiki.worldbank.org/Main_Page)
- [Asking for help with statistical programming](https://gist.github.com/bbdaniels/246867d78f07db5b2baecd0d8a22ef1a)
- [Introductory guides and cheat sheets for Stata](https://www.dropbox.com/sh/saq0usa4yhymjmx/AADPQ2ZY-Rs5gQ4d34IBmGNpa?dl=0)
- [How to access and read Stata documentation and help](https://www.stata.com/manuals/gsu4.pdf)
- [Debugging errors in Stata code](https://dimewiki.worldbank.org/Stata_Coding_Practices:_Debugging_)

Please feel free to flag down an instructor or assistant at any time! We are here to help. Thanks for joining the Stata lab sessions!
