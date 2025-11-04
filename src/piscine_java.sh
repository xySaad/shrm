lastfile() {
    ls -t $1 | grep -v '^build$' | head -1
}

piscinejava_test() {
    root=$(echo ~/xySaad/piscine-java/)
    exercise_name=""

    if [ -z "$1" ]; then
      exercise_name=$(lastfile $root)
    else
      exercise_name=$1
    fi

    # echo "runing local tests..." 
    # exercise_folder=$root$exercise_name
    # javac $exercise_folder/*.java -d $root/build
    # java -cp $root/build ExerciseRunner
    
    echo "runing docker tests..."

    sudo docker run --rm \
    -e EXERCISE=$exercise_name \
    -v $root:/app/student \
    ghcr.io/01-edu/test-java
}

piscinejava_new() {
 if [ -z "$1" ]; then 
    echo "exersice name argument required"
    return 1
 fi

 root=$(echo ~/xySaad/piscine-java/)
 mkdir $root$1

 piscinejava_pull $1 $root$1
 
 code $root$1/ExerciseRunner.java
 code $root$1/$1.java
}

gacp() {
    git add .
    
    if [ -n "$*" ]; then 
        git commit -m "$*"
    fi

    git push
}

piscinejava_pull() {
    file="$1"
    dest="$2"
    converted=$(echo "$1" | sed -E 's/([A-Z])/-\L\1/g' | sed 's/^-//')
    
    if [ -z "$file" ]; then
      echo "Usage: $0 <markdown-file>"
      returnc 1
    fi

    content=$(curl https://learn.zone01oujda.ma/api/content/root/01-edu_module/content/$converted/README.md)
    
    #(ai-code) Extract Expected Functions block (between ```java after "Expected Functions" and the next ```)
    echo "$content" | awk '
    /^### Expected Functions/ { in_section=1; next }
    /^```java/ && in_section && !in_code { in_code=1; next }
    /^```/ && in_section && in_code { in_code=0; in_section=0; next }
    in_section && in_code { print }
    ' > $2/$1.java

    #(ai-code) Extract Usage code block (the ```java one that follows "Usage")
    echo "$content" | awk '
    /^### Usage/ { in_section=1; next }
    /^```java/ && in_section && !in_code { in_code=1; next }
    /^```/ && in_section && in_code { in_code=0; in_section=0; next }
    in_section && in_code { print }
    ' > $2/ExerciseRunner.java
}