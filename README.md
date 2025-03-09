
```bash
pip3 install llm
llm --version
llm install llm-gemini
llm models default gemini-2.0-flash 
llm keys set gemini
llm 'hello world'

pip3 install files-to-prompt
files-to-prompt --version

cd <DIRECTORY>
files-to-prompt . | llm "What does this code do?"
````