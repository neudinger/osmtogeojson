import core.stdc.stdlib;
import std.stdio;
import std.string;
import std.getopt;
import std.file;
import std.path : buildNormalizedPath;
import std.json;
import std.xml;
import std.experimental.logger;

enum TagType
{
    node,
    way,
    relation
};

static string filePath;
static TagType tagType;
static string outputPath;


void main(string[] args)
{
    try
    {
        auto helpInformation = getopt(args, std.getopt.config.required,
                "input|i", "input file", &filePath, "output|o",
                "output file. Default is local directory with {input}.json",
                &outputPath, "tag|t",
                format!"Information about tags you want extract default tag is '%s'"(tagType),
                &tagType);

        if (helpInformation.helpWanted)
            {defaultGetoptPrinter("Please use this flags:", helpInformation.options);
            exit(0);}
    }
    catch (std.getopt.GetOptException)
    {
        "Please try with -h or --help".writeln;
        exit(0);
    }
    catch (object.Exception e)
    {
        (e.msg).writeln;
        exit(0);
    }
    try
    {
        if (!filePath.isFile)
        {
            "input file is not valid".writeln;
            exit(0);
        }

    }
    catch (std.file.FileException e)
    {
        (e.msg).writeln;
        exit(0);
    }

    outputPath = !outputPath ? filePath ~ ".json" : outputPath;
    auto jsfile = File(buildNormalizedPath(outputPath), "w");

    string xmlString = cast(string) std.file.read(filePath);
    "Parse the file".writeln;
    auto xml = new DocumentParser(xmlString);
    "File parsed".writeln;
    // node or way or relation
    string type = "node";
    xml.onStartTag[type] = (ElementParser node) {
        string[string] properties;
        JSONValue jnode = JSONValue(["type" : "Feature"]);
        jnode.object["id"] = node.tag.attr["id"];
        jnode.object["meta"] = node.tag.attr;
        jnode.object["meta"]["type"] = type;
        jnode.object["geometry"] = parseJSON(
                `{"type" : "Point", "coordinates" : [` ~ node.tag.attr["lon"]
                ~ `,` ~ node.tag.attr["lat"] ~ `]}`);
        node.onStartTag["tag"] = (ElementParser tags) {
            properties[tags.tag.attr["k"]] = tags.tag.attr["v"];
        };
        node.parse();
        if (properties)
            jnode.object["properties"] = JSONValue(properties);
        jsfile.write(jnode);
        jsfile.write("\n");
    };
    xml.parse();
    jsfile.close;
    writeln("File output is "~outputPath);
}
